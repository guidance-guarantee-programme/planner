class AppointmentEmailDecorator < SimpleDelegator
  def type_label
    entity.video_appointment? ? 'video ' : ''
  end

  def subject(suffix: '')
    "Your Pension Wise #{type_label.capitalize}Appointment#{suffix}"
  end
end
