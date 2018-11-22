class Appointment < ActiveRecord::Base # rubocop:disable ClassLength
  include PostalAddressable

  audited on: :update, except: %i(fulfilment_time_seconds fulfilment_window_seconds)

  enum status: %i(
    pending
    completed
    no_show
    ineligible_age
    ineligible_pension_type
    cancelled_by_customer
    cancelled_by_pension_wise
    cancelled_by_customer_sms
  )

  before_save :calculate_statistics, if: :proceeded_at_changed?
  before_create :track_status
  before_update :track_status_transition

  belongs_to :booking_request
  has_many :status_transitions

  delegate :reference, :activities, :agent_id?, :booking_location_id, to: :booking_request
  delegate :address_line_one, :address_line_two, :address_line_three, :town, :county, :postcode, to: :booking_request

  validates :name, presence: true
  validates :email, presence: true, email: true, unless: :agent_id?
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :accessibility_requirements, inclusion: { in: [true, false] }
  validates :defined_contribution_pot_confirmed, inclusion: { in: [true, false] }
  validates :location_id, presence: true
  validates :guider_id, presence: true
  validate  :validate_proceeded_at

  scope :not_booked_today, -> { where.not(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :with_mobile, -> { where("phone like '07%'") }
  scope :without_mobile, -> { where.not("phone like '07%'") }
  scope :with_email, -> { where.not(email: '') }

  def process!(by)
    return if processed_at?

    transaction do
      touch(:processed_at) # rubocop:disable SkipsModelValidations

      ProcessedActivity.from!(user: by, appointment: self)
    end
  end

  def cancel!
    without_auditing do
      transaction do
        update!(status: :cancelled_by_customer_sms)

        SmsCancellationActivity.from(self)
      end
    end
  end

  def updated?
    audits.present?
  end

  def notify?
    return if previous_changes.none? || proceeded_at.past?
    return true if previous_changes.exclude?(:status)

    previous_changes[:status] && pending?
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
    pending.not_booked_today.with_mobile.where(proceeded_at: [day_range(2), day_range(7)])
  end

  def self.needing_reminder
    not_booked_today.with_email.without_mobile.pending.where(proceeded_at: [day_range(2), day_range(7)])
  end

  def self.for_sms_cancellation(number)
    pending
      .order(created_at: :desc)
      .find_by("REPLACE(phone, ' ', '') = :number", number: number)
  end

  def self.day_range(days)
    days.days.from_now.beginning_of_day..days.days.from_now.end_of_day
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
end
