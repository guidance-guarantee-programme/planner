require 'securerandom'

FactoryGirl.define do
  factory :user do
    uid { SecureRandom.uuid }
    name 'Rick Sanchez'
    email 'rick@example.com'

    factory :pension_wise_api_user do
      permissions { Array(User::PENSION_WISE_API_PERMISSION) }
    end
  end
end
