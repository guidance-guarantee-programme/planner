class AuditActivity < Activity
  def self.from(audit, booking_request)
    create!(
      user_id: audit.user_id,
      message: audit.audited_changes.keys.map(&:humanize).to_sentence.downcase,
      booking_request_id: booking_request.id
    )
  end
end
