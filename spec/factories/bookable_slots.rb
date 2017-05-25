FactoryGirl.define do
  factory :bookable_slot do
    schedule
    date { Time.zone.now }

    trait :am do
      start '0900'
      add_attribute(:end, '1300')
    end

    trait :pm do
      start '1300'
      add_attribute(:end, '1700')
    end
  end
end
