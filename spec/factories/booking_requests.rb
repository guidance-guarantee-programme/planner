require 'securerandom'

FactoryBot.define do
  factory :booking_request do
    booking_location_id { SecureRandom.uuid }
    location_id { SecureRandom.uuid }
    name { 'Morty Sanchez' }
    email { 'morty@example.com' }
    phone { '0208 252 4723' }
    memorable_word { 'spaceship' }
    age_range { '50-54' }
    date_of_birth { '1950-01-01' }
    additional_info { '' }
    accessibility_requirements { true }
    gdpr_consent { 'yes' }
    defined_contribution_pot_confirmed { true }
    placed_by_agent { false }
    address_line_one { '10 Some Road' }
    town { 'Some Town' }
    postcode { 'W1 1AA' }
    agent { nil }

    transient { number_of_slots { 1 } }

    after(:build) do |booking_request, evaluator|
      (1..evaluator.number_of_slots).each do |slot_number|
        booking_request.slots << build(:slot, priority: slot_number)
      end
    end

    factory :hackney_booking_request do
      booking_location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
      location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
    end

    factory :hackney_child_booking_request do
      booking_location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
      location_id { '89821b79-b132-4893-bc9f-c247dd9009fd' }
    end

    factory :taunton_child_booking_request do
      booking_location_id { '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4' }
      location_id { '13e12f95-f709-4536-b6ee-8d7a735ddf9f' }
    end

    factory :taunton_booking_request do
      booking_location_id { '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4' }
      location_id { '7f916cf6-d2bd-4bcc-90dc-594207c8b1f4' }
    end

    factory :postal_booking_request do
      booking_location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
      location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }

      address_line_one { '22 Dalston Lane' }
      address_line_two { '' }
      address_line_three { '' }
      town { 'Hackney' }
      county { 'London' }
      postcode { 'E8 3AZ' }

      agent
      email { '' }
    end
  end
end
