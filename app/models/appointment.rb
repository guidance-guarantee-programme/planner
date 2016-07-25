class Appointment < ActiveRecord::Base
  belongs_to :booking_request

  delegate :reference, to: :booking_request
end
