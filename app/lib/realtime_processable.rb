module RealtimeProcessable
  def process_booking_request(booking_request)
    return send_notifications(booking_request) unless booking_request.realtime?

    appointment = fulfil_appointment(booking_request)
    appointment = Appointment.create!(appointment.appointment_params)

    AppointmentChangeNotificationJob.perform_later(appointment)
    PrintedConfirmationLetterJob.perform_later(appointment)
  end

  def fulfil_appointment(booking_request)
    AppointmentForm.new(
      location_aware_booking_request(booking_request),
      'date'      => booking_request.allocated.start_at.to_date.to_s,
      'time(4i)'  => booking_request.allocated.start_at.strftime('%H'),
      'time(5i)'  => booking_request.allocated.start_at.strftime('%M'),
      'guider_id' => booking_request.allocated.guider_id
    )
  end

  def location_aware_booking_request(booking_request)
    LocationAwareEntity.new(
      entity: booking_request,
      booking_location: BookingLocations.find(booking_request.booking_location_id)
    )
  end
end
