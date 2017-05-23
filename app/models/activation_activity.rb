class ActivationActivity < Activity
  def self.from(booking_request, initiator, reason = '')
    message = if reason.present?
                "'#{booking_request.status.humanize}', reason given '#{reason}'"
              else
                booking_request.status.humanize
              end

    create!(
      booking_request: booking_request,
      message: message.downcase,
      user: initiator
    )
  end
end
