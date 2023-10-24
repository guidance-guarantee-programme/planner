# rubocop:disable Rails/Date
FactoryBot.define do
  factory :bookable_slot do
    schedule
    guider_id { 1 }
    start_at { Time.current.change(hour: 9) }
    end_at { start_at.to_time.advance(hour: 1) }
  end
end
# rubocop:enable Rails/Date
