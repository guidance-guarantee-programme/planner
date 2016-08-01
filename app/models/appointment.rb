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
end
