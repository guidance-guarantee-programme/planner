FactoryBot.define do
  factory :slot do
    date { "2016-06-#{Array(20..24).sample}" }
    from { BookableSlot::AM.start }
    to   { BookableSlot::AM.end }
    priority { 1 }
  end
end
