class AuditActivity < Activity
  def self.from(audit, audited_changes, booking_request)
    create!(
      user_id: audit.user_id,
      message: audited_changes.keys.map(&:humanize).join(', ').downcase,
      booking_request_id: booking_request.id
    )
  end

  def changed_attributes
    message.split(', ')
  end
end
