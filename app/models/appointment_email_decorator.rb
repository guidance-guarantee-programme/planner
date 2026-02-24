class AppointmentEmailDecorator < SimpleDelegator
  def type_label
    entity.video_appointment? ? 'video ' : ''
  end

  def subject(suffix: '')
    "Your Pension Wise #{type_label.capitalize}Appointment#{suffix}"
  end

  def online_booking_twilio_number
    UKPhoneNumbers.format(super)
  end
end
