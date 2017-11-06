FactoryBot.define do
  factory :appointment do
    location_id 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
    association :booking_request, factory: :hackney_booking_request
    name 'Mortimer Smith'
    email 'morty@example.com'
    phone '07719 334 5678'
    memorable_word 'spaceships'
    defined_contribution_pot_confirmed true
    accessibility_requirements false
    date_of_birth '1950-01-01'
    guider_id 1
    proceeded_at Time.zone.parse('2016-06-20 14:00')
  end
end
