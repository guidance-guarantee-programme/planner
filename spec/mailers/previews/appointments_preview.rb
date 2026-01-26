class AppointmentsPreview < ActionMailer::Preview
  def booking_manager_appointment_changed
    @booking_manager = User.first || FactoryBot.create(:hackney_booking_manager)
    @appointment     = Appointment.first || FactoryBot.create(:appointment, :video)

    # force an audit to be present
    @appointment.update(name: 'Bob Jones', email: 'bleh@example.com')

    Appointments.booking_manager_appointment_changed(@appointment, @booking_manager)
  end

  def customer_video_appointment
    Appointments.customer_video_appointment(
      Appointment.first,
      booking_location
    )
  end

  def cancellation
    Appointments.cancellation(Appointment.first || FactoryBot.create(:appointment))
  end

  def customer
    Appointments.customer(
      Appointment.first,
      booking_location
    )
  end

  def reminder
    Appointments.reminder(
      Appointment.first,
      booking_location
    )
  end

  def missed
    Appointments.missed(Appointment.first)
  end

  def confirmation_with_bsl
    @appointment = Appointment.first
    @appointment.booking_request.bsl = true

    Appointments.customer(@appointment, booking_location)
  end

  private

  def booking_location
    BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end
end
