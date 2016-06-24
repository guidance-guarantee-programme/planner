FactoryGirl.define do
  factory :slot do
    date { "2016-01-#{Array(1..31).sample}" }
    from '0900'
    to '1300'
    priority 1
  end
end
