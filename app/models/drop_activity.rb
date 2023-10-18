class DropActivity < Activity
  def self.from(message_type, description, booking_request)
    create(
      message: "#{message_from(message_type)}#{description}",
      booking_request_id: booking_request.id
    )
  end

  def self.message_from(message_type)
    return '' unless message_type

    "#{message_type.humanize.downcase} - "
  end
end
