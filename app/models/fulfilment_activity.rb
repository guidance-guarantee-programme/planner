class FulfilmentActivity < Activity
  def self.from(appointment, owner)
    create!(
      booking_request: appointment.booking_request,
      user: owner,
      message: ''
    )
  end
end
