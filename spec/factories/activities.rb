FactoryBot.define do
  factory :activity do
    user
    booking_request
    message 'did a thing to a thing'
    type 'AuditActivity'
  end

  factory :reminder_activity do
    booking_request
    message ''
    type 'ReminderActivity'
  end
end
