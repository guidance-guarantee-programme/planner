class Appointment < ActiveRecord::Base # rubocop:disable ClassLength
  include PostalAddressable

  audited on: :update, except: %i(fulfilment_time_seconds fulfilment_window_seconds)

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

  enum status: %i(
    pending
    completed
    no_show
    ineligible_age
    ineligible_pension_type
    cancelled_by_customer
    cancelled_by_pension_wise
    cancelled_by_customer_sms
    incomplete_other
  )

  before_save :calculate_statistics, if: :proceeded_at_changed?
  before_create :track_status
  before_update :track_status_transition

  belongs_to :booking_request
  has_many :status_transitions

  delegate :realtime?, :reference, :activities, :agent_id?, :booking_location_id, to: :booking_request
  delegate :address_line_one, :address_line_two, :address_line_three, :town, :county, :postcode, to: :booking_request
  delegate :pension_provider, to: :booking_request

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

  def duplicates # rubocop:disable AbcSize
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
      touch(:processed_at) # rubocop:disable SkipsModelValidations

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

  def cancel!
    without_auditing do
      transaction do
        update_attribute(:status, :cancelled_by_customer_sms) # rubocop:disable SkipsModelValidations

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
    audits.present?
  end

  def notify?
    return if previous_changes.none? || proceeded_at.past?
    return true if previous_changes.exclude?(:status)

    previous_changes[:status] && pending?
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
      .where.not(status: [5, 6, 7], id: id)
  end

  private

  def track_status
    status_transitions << StatusTransition.new(status: status)
  end

  def track_status_transition
    track_status if status_changed?
  end

  def after_audit
    AuditActivity.from(audits.last, booking_request)
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
    errors.add(:proceeded_at, 'must be present') unless proceeded_at.present?

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

  def validate_secondary_status # rubocop:disable AbcSize, PerceivedComplexity, CyclomaticComplexity, MethodLength
    return unless created_at && created_at > Time.zone.parse(
      ENV.fetch('SECONDARY_STATUS_CUT_OFF') { '2022-06-08 09:00' }
    )

    if matches = SECONDARY_STATUSES[status] # rubocop:disable GuardClause
      unless matches.key?(secondary_status)
        return errors.add(:secondary_status, 'must be provided for the chosen status')
      end

      if current_user.agent? && cancelled_by_customer? && secondary_status != AGENT_PERMITTED_SECONDARY
        errors.add(:secondary_status, "Contact centre agents should only select 'Cancelled prior to appointment'")
      end
    end
  end
end
