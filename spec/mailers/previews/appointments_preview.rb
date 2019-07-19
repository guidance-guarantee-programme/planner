class AppointmentsPreview < ActionMailer::Preview
  def cancellation
    Appointments.cancellation(Appointment.first || FactoryBot.create(:appointment))
  end

  def customer
    Appointments.customer(
      FactoryBot.create(:appointment),
      booking_location
    )
  end

  def reminder
    Appointments.reminder(
      FactoryBot.create(:appointment),
      booking_location
    )
  end

  private

  def booking_location
    BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end
end
