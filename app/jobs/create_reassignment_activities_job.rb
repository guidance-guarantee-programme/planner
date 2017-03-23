class CreateReassignmentActivitiesJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request_ids)
    booking_request_ids.each do |booking_request_id|
      ReassignmentActivity.create!(
        booking_request_id: booking_request_id,
        message: ''
      )
    end
  end
end
