require 'securerandom'

FactoryBot.define do
  factory :user do
    uid { SecureRandom.uuid }
    name 'Rick Sanchez'
    email 'rick@example.com'

    factory :pension_wise_api_user do
      permissions { Array(User::PENSION_WISE_API_PERMISSION) }
    end

    factory :booking_manager do
      permissions { Array(User::BOOKING_MANAGER_PERMISSION) }
    end

    factory :hackney_booking_manager, parent: :booking_manager do
      organisation_content_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
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
