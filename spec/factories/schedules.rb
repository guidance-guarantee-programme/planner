FactoryBot.define do
  factory :schedule do
    # Hackney
    location_id { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }

    trait :dalston do
      location_id { '183080c6-642b-4b8f-96fd-891f5cd9f9c7' }
    end
  end
end
