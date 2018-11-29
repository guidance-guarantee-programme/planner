FactoryBot.define do
  factory :bookable_slot do
    schedule
    date { Time.zone.now }

    trait :realtime do
      guider_id { 1 }
      start { '0900' }
      add_attribute(:end) { '1000' }
    end

    trait :am do
      start { BookableSlot::AM.start }
      add_attribute(:end) { BookableSlot::AM.end }
    end

    trait :pm do
      start { BookableSlot::PM.start }
      add_attribute(:end) { BookableSlot::PM.end }
    end
  end
end
