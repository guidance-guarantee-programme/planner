module BookingManagerable
  def booking_managers_for(booking_location_id)
    return [Appointment::CAS_BOOKING_MANAGER_ALIAS] if booking_location_id == Appointment::CAS_BOOKING_LOCATION_ID

    User.booking_managers(booking_location_id)
  end
end
