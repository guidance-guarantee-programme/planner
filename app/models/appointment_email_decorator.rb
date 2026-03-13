class AppointmentEmailDecorator < SimpleDelegator
  def type_label
    if entity.bsl_video?
      'video appointment in BSL '
    elsif entity.video_appointment?
      'video appointment '
    else
      'appointment '
    end
  end

  def subject(suffix: '')
    "Your Pension Wise #{type_label}#{suffix}".squish
  end

  def online_booking_twilio_number
    UKPhoneNumbers.format(super)
  end
end
