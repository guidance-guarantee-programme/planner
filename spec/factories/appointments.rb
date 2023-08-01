FactoryBot.define do
  factory :appointment do
    location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
    association :booking_request, factory: :hackney_booking_request
    name { 'Mortimer Smith' }
    email { 'morty@example.com' }
    phone { '07719 334 5678' }
    memorable_word { 'spaceships' }
    defined_contribution_pot_confirmed { true }
    accessibility_requirements { false }
    date_of_birth { '1950-01-01' }
    guider_id { 1 }
    proceeded_at { Time.zone.parse('2016-06-20 14:00') }

    trait :with_address do
      email { '' }
      association :booking_request, factory: :postal_booking_request
    end

    trait :with_agent do
      association :booking_request, factory: :agent_booking_request
    end

    trait :taunton_booking_location do
      guider_id { 2 }
      location_id { '13e12f95-f709-4536-b6ee-8d7a735ddf9f' }

      association :booking_request, factory: :taunton_child_booking_request
    end

    trait :drumchapel_booking_location do
      guider_id { 2 }
      location_id { '0c686436-de02-4d92-8dc7-26c97bb7c5bb' }

      association :booking_request, factory: :drumchapel_booking_request
    end

    trait :third_party_booking do
      third_party { true }
    end

    trait :third_party_consent_form_requested do
      association :booking_request, factory: :third_party_consent_form_booking_request
    end

    trait :third_party_email_consent_form_requested do
      association :booking_request, factory: :third_party_email_consent_form_booking_request
    end
  end
end
