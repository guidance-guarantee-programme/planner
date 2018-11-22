class ProcessedActivity < Activity
  def self.from!(user:, appointment:)
    create!(
      user: user,
      booking_request: appointment.booking_request,
      message: ''
    )
  end
end
