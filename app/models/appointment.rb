class Appointment < ActiveRecord::Base
  audited on: [:update]

  enum status: %i(
    pending
    completed
    no_show
    ineligible_age
    ineligible_pension_type
    cancelled_by_customer
    cancelled_by_pension_wise
  )

  before_validation :calculate_fulfilment_time, if: :proceeded_at_changed?
  before_validation :calculate_fulfilment_window, if: :proceeded_at_changed?

  belongs_to :booking_request

  delegate :reference, to: :booking_request

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :location_id, presence: true
  validates :guider_id, presence: true
  validate  :validate_proceeded_at

  def updated?
    audits.present?
  end

  def notify?
    previous_changes.exclude?(:status)
  end

  private

  def calculate_fulfilment_time
    self.fulfilment_time_seconds = (proceeded_at.to_i - booking_request.created_at.to_i).abs
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
