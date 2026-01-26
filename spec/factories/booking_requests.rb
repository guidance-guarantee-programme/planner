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

    factory :bsl_booking_request do
      bsl { true }
    end

    factory :video_booking_request do
      video_appointment { true }
    end

    factory :agent_booking_request do
      agent
      booking_location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
      location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
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

    factory :drumchapel_booking_request do
      booking_location_id { '0c686436-de02-4d92-8dc7-26c97bb7c5bb' }
      location_id { '0c686436-de02-4d92-8dc7-26c97bb7c5bb' }
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

    factory :third_party_consent_form_booking_request do
      third_party { true }
      data_subject_name { 'Daisy Smith' }
      data_subject_date_of_birth { '1975-01-01' }
      printed_consent_form_required { true }
      consent_address_line_one { '1 Some Street' }
      consent_address_line_two { 'Some Place' }
      consent_address_line_three { 'Somewhere' }
      consent_town { 'Some Town' }
      consent_county { 'Some County' }
      consent_postcode { 'SS1 1SS' }
    end

    factory :third_party_email_consent_form_booking_request do
      third_party { true }
      data_subject_name { 'Daisy Smith' }
      data_subject_date_of_birth { '1975-01-01' }
      email_consent_form_required { true }
      email_consent { 'daisy@example.com' }
    end

    factory :third_party_power_of_attorney_booking_request do
      third_party { true }
      data_subject_name { 'Daisy Smith' }
      data_subject_date_of_birth { '1975-01-01' }
      power_of_attorney { true }
      power_of_attorney_evidence do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/evidence.pdf'), 'application/pdf')
      end
    end

    factory :third_party_data_subject_consent_booking_request do
      third_party { true }
      data_subject_name { 'Daisy Smith' }
      data_subject_date_of_birth { '1975-01-01' }
      data_subject_consent_obtained { true }
      data_subject_consent_evidence do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/evidence.pdf'), 'application/pdf')
      end
    end
  end
end
