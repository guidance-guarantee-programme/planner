class VideoCustomerExitPollActivity < Activity
  def self.from(appointment)
    create!(
      booking_request: appointment.booking_request,
      message: ''
    )
  end
end
