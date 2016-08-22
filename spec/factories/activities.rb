FactoryGirl.define do
  factory :activity do
    user
    booking_request
    message 'did a thing to a thing'
  end
end
