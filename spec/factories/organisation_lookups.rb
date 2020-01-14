FactoryBot.define do
  factory :organisation_lookup do
    trait :cas do
      location_id { '0c686436-de02-4d92-8dc7-26c97bb7c5bb' }
      organisation { 'cas' }
    end

    trait :pwni do
      location_id { 'beafeb21-7cd6-4a88-a372-d632fc63f291' }
      organisation { 'nicab' }
    end
  end
end
