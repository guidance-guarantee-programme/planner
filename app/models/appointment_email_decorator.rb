class AppointmentEmailDecorator < SimpleDelegator
  def type_label
    if entity.bsl_video?
      'BSL Video '
    elsif entity.video_appointment?
      'Video '
    else
      ''
    end
  end

  def subject(suffix: '')
    "Your Pension Wise #{type_label}Appointment#{suffix}".squish
  end

  def online_booking_twilio_number
    UKPhoneNumbers.format(super)
  end
end
