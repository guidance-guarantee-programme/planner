class Appointment < ActiveRecord::Base # rubocop:disable Metrics/ClassLength
  include PostalAddressable

  audited on: :update, except: %i(fulfilment_time_seconds fulfilment_window_seconds)
  has_associated_audits

  CAS_BOOKING_LOCATION_ID   = '0c686436-de02-4d92-8dc7-26c97bb7c5bb'.freeze
  AGENT_PERMITTED_SECONDARY = '15'.freeze
  SECONDARY_STATUSES = {
    'incomplete_other' => {
      '0' => 'Technological issue',
      '1' => 'Guider issue',
      '2' => 'Customer issue',
      '3' => 'Customer had accessibility requirement',
      '4' => 'Customer believed Pension Wise was mandatory',
      '5' => 'Customer wanted specific questions answered',
      '6' => 'Customer did not want to hear all payment options',
      '7' => 'Customer wanted advice not guidance',
      '8' => 'Customer behaviour',
      '9' => 'Other'
    },
    'ineligible_pension_type' => {
      '10' => 'DB pension only and not considering transferring',
      '11' => 'Annuity in payment only',
      '12' => 'State pension only',
      '13' => 'Overseas pension only',
      '14' => 'S32 – No GMP Excess'
    },
    'cancelled_by_customer' => {
      '15' => 'Cancelled prior to appointment',
      '16' => 'Inconvenient time',
      '17' => 'Customer forgot',
      '18' => 'Customer changed their mind',
      '19' => 'Customer not sufficiently prepared to undertake the call',
      '20' => 'Customer did not agree with data protection policy',
      '21' => 'Duplicate appointment booked by customer',
      '22' => 'Customer driving whilst having appointment',
      '23' => 'Third-party consent not received'
    }
  }.freeze

  enum status: { :pending => 0, :completed => 1, :no_show => 2, :ineligible_age => 3, :ineligible_pension_type => 4,
                 :cancelled_by_customer => 5, :cancelled_by_pension_wise => 6, :cancelled_by_customer_sms => 7,
                 :incomplete_other => 8 }

  before_save :calculate_statistics, if: :proceeded_at_changed?
  before_create :track_status
  before_update :track_status_transition
  before_validation :purge_third_party, on: :update

  belongs_to :booking_request
  has_many :status_transitions, dependent: :destroy

  accepts_nested_attributes_for :booking_request, update_only: true

  has_one_attached :generated_consent_form

  delegate :realtime?, :reference, :activities, :agent_id?, :booking_location_id, :agent, to: :booking_request
  delegate :address_line_one, :address_line_two, :address_line_three, :town, :county, :postcode, to: :booking_request
  delegate :pension_provider, :adjustment?, :bsl?, to: :booking_request

  validates :name, presence: true
  validates :email, presence: true, email: true, unless: :agent_id?
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :accessibility_requirements, inclusion: { in: [true, false] }
  validates :defined_contribution_pot_confirmed, inclusion: { in: [true, false] }
  validates :location_id, presence: true
  validates :guider_id, presence: true
  validate  :validate_proceeded_at
  validate  :validate_guider_availability
  validate  :validate_secondary_status

  scope :not_booked_today, -> { where.not(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :with_mobile, -> { where("phone like '07%'") }
  scope :without_mobile, -> { where.not("phone like '07%'") }
  scope :with_email, -> { where.not(email: '') }

  attr_accessor :current_user

  def duplicates # rubocop:disable Metrics/AbcSize
    scope = self.class.joins(:booking_request)
                .where(booking_requests: { booking_location_id: booking_location_id })
                .where.not(id: id)

    scope.where(name: name)
         .or(scope.where(phone: phone))
         .or(scope.where.not(email: '').where(email: email))
         .order('booking_requests.id')
         .pluck('booking_requests.id', :id)
  end

  def duplicates?
    duplicates.size.positive?
  end

  def process!(by)
    return if processed_at?

    transaction do
      touch(:processed_at) # rubocop:disable Rails/SkipsModelValidations

      ProcessedActivity.from!(user: by, appointment: self)
    end
  end

  def allocate!(slot_date_time)
    return unless slot = Schedule.allocate_slot(self, slot_date_time)

    self.guider_id    = slot.guider_id
    self.proceeded_at = slot.start_at

    save
  end

  def cancelled?
    status.starts_with?('cancelled')
  end

  def newly_cancelled?
    cancelled? && previous_changes.include?(:status)
  end

  def bsl_newly_completed?
    !cas? && bsl? && completed? && previous_changes.include?(:status)
  end

  def cas?
    booking_location_id == CAS_BOOKING_LOCATION_ID
  end

  def notify_email_consent?
    return unless pending? && booking_request.email_consent_form_required?

    booking_request.previous_changes.include?(:email_consent_form_required)
  end

  def notify_printed_consent?
    return unless pending? && booking_request.printed_consent_form_required?

    booking_request.previous_changes.include?(:printed_consent_form_required)
  end

  def cancel!
    without_auditing do
      transaction do
        update_attribute(:status, :cancelled_by_customer_sms) # rubocop:disable Rails/SkipsModelValidations

        SmsCancellationActivity.from(self)
      end
    end
  end

  def cancel_by_agent!(agent)
    self.current_user = agent
    self.status = :cancelled_by_customer
    self.secondary_status = AGENT_PERMITTED_SECONDARY # cancelled prior to appointment
    save
  end

  def updated?
    own_and_associated_audits.present?
  end

  def notify?
    return false if proceeded_at.past?
    return true  if previous_changes.any? && previous_changes.exclude?(:status)
    return true  if booking_request.previous_changes.any? && booking_request.previous_changes.exclude?(:updated_at)

    previous_changes[:status] && pending?
  end

  def latest_audit_activity
    activities.where(type: 'AuditActivity').order(created_at: :desc).first
  end

  def hrh_bank_holiday?
    proceeded_at.to_date == '2022-09-19'.to_date
  end

  def calculate_statistics
    calculate_fulfilment_time
    calculate_fulfilment_window
  end

  def created_at
    super || Time.zone.now
  end

  def timezone
    proceeded_at.in_time_zone('London').utc_offset.zero? ? 'GMT' : 'BST'
  end

  def self.needing_sms_reminder
    pending.not_booked_today.with_mobile.where(proceeded_at: [day_range(3), day_range(7)])
  end

  def self.needing_reminder
    not_booked_today.with_email.without_mobile.pending.where(proceeded_at: [day_range(3), day_range(7)])
  end

  def self.for_sms_cancellation(number)
    pending
      .order(:created_at)
      .find_by("REPLACE(phone, ' ', '') = :number", number: number)
  end

  def self.day_range(days)
    days.days.from_now.beginning_of_day..days.days.from_now.end_of_day
  end

  def self.realtime_appointments(location_id, date_range)
    where(proceeded_at: date_range, location_id: location_id)
  end

  def self.overlaps?(guider_id:, proceeded_at:, id: nil, location_id: nil)
    return if location_id == 'a801a72d-91be-4a33-86a6-3d652cfc00d0' # Reading

    overlapping(guider_id: guider_id, proceeded_at: proceeded_at, id: id).size.positive?
  end

  def self.overlapping(guider_id:, proceeded_at:, id: nil)
    where(guider_id: guider_id)
      .where("(proceeded_at, interval '1 hour') overlaps (?, interval '1 hour')", proceeded_at)
      .where.not(status: [5, 6, 7])
      .where.not(id: id)
  end

  private

  def purge_third_party
    booking_request.third_party = false if third_party_changed? && !third_party?
  end

  def track_status
    status_transitions << StatusTransition.new(status: status)
  end

  def track_status_transition
    track_status if status_changed?
  end

  def after_audit
    last_audit = own_and_associated_audits.order(created_at: :desc).first
    combined   = combined_audits(last_audit)

    AuditActivity.from(
      last_audit,
      combined,
      booking_request
    )
  end

  def combined_audits(source)
    return source.audited_changes unless source.request_uuid?

    own_and_associated_audits
      .where(request_uuid: source.request_uuid)
      .pluck(:audited_changes)
      .reduce(&:merge)
  end

  def calculate_fulfilment_time
    self.fulfilment_time_seconds =
      (created_at.to_i - booking_request.created_at.to_i).abs
  end

  def calculate_fulfilment_window
    return unless booking_request.primary_slot

    self.fulfilment_window_seconds =
      (proceeded_at.to_i - booking_request.primary_slot.mid_point.to_i).abs
  end

  def validate_proceeded_at
    errors.add(:proceeded_at, 'must be present') if proceeded_at.blank?

    Time.zone.parse(proceeded_at.to_s)
  rescue ArgumentError
    errors.add(:proceeded_at, 'must be formatted correctly')
  end

  def validate_guider_availability
    return unless guider_id? && proceeded_at?

    if self.class.overlaps?(
      guider_id: guider_id, proceeded_at: proceeded_at, id: id, location_id: location_id
    )
      errors.add(:guider_id, 'is already booked with an overlapping appointment')
    end
  end

  def validate_secondary_status
    return unless matches = SECONDARY_STATUSES[status]
    return errors.add(:secondary_status, 'must be provided for the chosen status') unless matches.key?(secondary_status)

    return unless current_user&.agent? && cancelled_by_customer? && secondary_status != AGENT_PERMITTED_SECONDARY

    errors.add(:secondary_status, "Contact centre agents should only select 'Cancelled prior to appointment'")
  end
end
