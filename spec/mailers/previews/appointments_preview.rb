class AppointmentsPreview < ActionMailer::Preview
  def booking_manager_appointment_changed
    @booking_manager = User.first || FactoryBot.create(:hackney_booking_manager)
    @appointment     = Appointment.first || FactoryBot.create(:appointment, :video)

    # force an audit to be present
    @appointment.update(name: 'Bob Jones', email: 'bleh@example.com')

    Appointments.booking_manager_appointment_changed(@appointment, @booking_manager)
  end

  def customer_video_appointment
    appointment = Appointment.first
    appointment.booking_request.video_appointment = true
    appointment.booking_request.bsl = false
    appointment.booking_request.video_appointment_url = 'https://teams.microsoft.com/12345678?p=deadbeef'

    Appointments.customer_video_appointment(
      appointment,
      booking_location
    )
  end

  def cancellation
    appointment = Appointment.first

    Appointments.cancellation(appointment)
  end

  def customer
    appointment = Appointment.first

    Appointments.customer(
      appointment,
      booking_location
    )
  end

  def reminder
    appointment = Appointment.first

    Appointments.reminder(
      appointment,
      booking_location
    )
  end

  def missed
    appointment = Appointment.first

    Appointments.missed(appointment)
  end

  def confirmation_with_bsl
    @appointment = Appointment.first
    @appointment.booking_request.bsl = true

    Appointments.customer(@appointment, booking_location)
  end

  def video_customer_exit_poll
    appointment = Appointment.first
    appointment.booking_request.video_appointment = true
    appointment.booking_request.bsl = false
    appointment.booking_request.video_appointment_url = 'https://teams.microsoft.com/12345678?p=deadbeef'

    Appointments.video_customer_exit_poll(appointment)
  end

  private

  def booking_location
    BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end
end
