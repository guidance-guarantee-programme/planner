require 'securerandom'

FactoryBot.define do
  factory :user do
    uid { SecureRandom.uuid }
    name { 'Rick Sanchez' }
    email { 'rick@example.com' }

    factory :agent_manager do
      permissions { Array(User::AGENT_MANAGER_PERMISSION) }
    end

    factory :agent do
      permissions { Array(User::AGENT_PERMISSION) }
    end

    factory :pension_wise_api_user do
      permissions { Array(User::PENSION_WISE_API_PERMISSION) }
    end

    factory :booking_manager do
      permissions { Array(User::BOOKING_MANAGER_PERMISSION) }
    end

    factory :ops_booking_manager, parent: :booking_manager do
      organisation_content_id { Appointment::OPS_BOOKING_LOCATION_ID }
    end

    factory :ops_agent_manager, parent: :agent_manager do
      organisation_content_id { Appointment::OPS_BOOKING_LOCATION_ID }
    end

    factory :cardiff_and_vale_booking_manager, parent: :booking_manager do
      organisation_content_id { '525da418-ff2c-4522-90a9-bc70ba4ca78b' }
    end

    factory :drumchapel_booking_manager, parent: :booking_manager do
      organisation_content_id { '0c686436-de02-4d92-8dc7-26c97bb7c5bb' }
    end

    factory :hackney_booking_manager, parent: :booking_manager do
      organisation_content_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
    end

    factory :org_admin do
      permissions { [User::ORG_ADMIN_PERMISSION, User::BOOKING_MANAGER_PERMISSION] }
      organisation_content_id { SecureRandom.uuid } # random so it's not assigned
    end

    factory :hackney_administrator, parent: :hackney_booking_manager do
      permissions do
        [
          User::BOOKING_MANAGER_PERMISSION,
          User::ADMINISTRATOR_PERMISSION
        ]
      end
    end
  end
end
