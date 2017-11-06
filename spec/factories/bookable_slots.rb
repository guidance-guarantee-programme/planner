FactoryBot.define do
  factory :bookable_slot do
    schedule
    date { Time.zone.now }

    trait :am do
      start BookableSlot::AM.start
      add_attribute(:end, BookableSlot::AM.end)
    end

    trait :pm do
      start BookableSlot::PM.start
      add_attribute(:end, BookableSlot::PM.end)
    end
  end
end
