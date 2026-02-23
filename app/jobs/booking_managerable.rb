module BookingManagerable
  def booking_managers_for(booking_location_id)
    return [Appointment::CAS_BOOKING_MANAGER_ALIAS] if booking_location_id == Appointment::CAS_BOOKING_LOCATION_ID

    if booking_location_id == Appointment::OPS_BOOKING_LOCATION_ID
      return ENV.fetch('OPS_BOOKING_MANAGER_ALIASES') { Appointment::OPS_BOOKING_MANAGER_ALIAS }.split(',')
    end

    User.booking_managers(booking_location_id).pluck(:email)
  end
end
