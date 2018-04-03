FactoryBot.define do
  factory :schedule do
    # Hackney
    location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'

    trait :blank do
      Schedule::SLOT_ATTRIBUTES.each do |attribute|
        add_attribute(attribute, false)
      end
    end

    trait :dalston do
      location_id '183080c6-642b-4b8f-96fd-891f5cd9f9c7'
    end

    trait :belfast_central do
      location_id '1de9b76c-c349-4e2a-a3a7-bb0f59b0807e'
    end
  end
end
