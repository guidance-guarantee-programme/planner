FactoryGirl.define do
  factory :schedule do
    # Hackney
    location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'

    trait :blank do
      Schedule::SLOT_ATTRIBUTES.each do |attribute|
        add_attribute(attribute, false)
      end
    end
  end
end
