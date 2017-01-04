class ActivationActivity < Activity
  def self.from(booking_request, initiator)
    create!(
      booking_request: booking_request,
      message: booking_request.active? ? 'active' : 'inactive',
      user: initiator
    )
  end
end
