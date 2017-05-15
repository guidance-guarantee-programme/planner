class ActivationActivity < Activity
  def self.from(booking_request, initiator)
    create!(
      booking_request: booking_request,
      message: booking_request.state,
      user: initiator
    )
  end
end
