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
    date_of_birth '1950-01-01'
    additional_info ''
    accessibility_requirements true
    marketing_opt_in false
    defined_contribution_pot_confirmed true

    after(:build) do |booking_request|
      booking_request.slots << build(:slot, priority: 1)
      booking_request.slots << build(:slot, priority: 2)
      booking_request.slots << build(:slot, priority: 3)
    end

    factory :hackney_booking_request do
      booking_location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
      location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
    end

    factory :hackney_child_booking_request do
      booking_location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
      location_id '89821b79-b132-4893-bc9f-c247dd9009fd'
    end

    factory :taunton_child_booking_request do
      booking_location_id '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4'
      location_id '13e12f95-f709-4536-b6ee-8d7a735ddf9f'
    end

    factory :taunton_booking_request do
      booking_location_id '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4'
      location_id '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4'
    end
  end
end
