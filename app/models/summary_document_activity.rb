class SummaryDocumentActivity < Activity
  def self.from(booking_request_id:, owner_uid:, delivery_method:)
    new(
      booking_request: BookingRequest.find(booking_request_id),
      user: User.find_by(uid: owner_uid),
      message: delivery_method
    ).save!
  end
end
