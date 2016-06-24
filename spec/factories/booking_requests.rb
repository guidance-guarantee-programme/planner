require 'securerandom'

FactoryGirl.define do
  factory :booking_request do
    location_id { SecureRandom.uuid }
    name 'Morty Sanchez'
    email 'morty@example.com'
    phone '0208 252 4723'
    memorable_word 'spaceship'
    age_range '50-54'
    accessibility_requirements false
    marketing_opt_in false
    defined_contribution_pot true

    factory :booking_request_with_slots do
      after(:create) do |booking_request|
        3.times { |i| create(:slot, priority: i + 1, booking_request: booking_request) }
      end
    end
  end
end
