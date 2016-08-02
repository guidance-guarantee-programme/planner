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

  private

  def validate_proceeded_at
    errors.add(:proceeded_at, 'must be present') unless proceeded_at.present?

    Time.zone.parse(proceeded_at.to_s)
  rescue ArgumentError
    errors.add(:proceeded_at, 'must be formatted correctly')
  end
end
