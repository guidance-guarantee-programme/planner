FactoryBot.define do
  factory :slot do
    date { "2016-06-#{Array(20..24).sample}" }
    from { '0900' }
    to   { '1300' }
    priority { 1 }
  end
end
