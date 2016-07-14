require 'securerandom'

FactoryGirl.define do
  factory :booking_request do
    booking_location_id { SecureRandom.uuid }
    location_id { SecureRandom.uuid }
    name 'Morty Sanchez'
    email 'morty@example.com'
    phone '0208 252 4723'
    memorable_word 'spaceship'
    age_range '50-54'
    accessibility_requirements false
    marketing_opt_in false
    defined_contribution_pot true

    after(:build) do |booking_request|
      booking_request.slots << build(:slot, priority: 1)
      booking_request.slots << build(:slot, priority: 2)
      booking_request.slots << build(:slot, priority: 3)
    end
  end
end
