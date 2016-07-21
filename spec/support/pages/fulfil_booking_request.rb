module Pages
  class FulfilBookingRequest < SitePrism::Page
    set_url '/booking_requests/{booking_request_id}/appointments/new'

    element :name, '.t-name'
    element :reference, '.t-reference'
    element :email, '.t-email'
    element :location, '.t-location'
    element :memorable_word, '.t-memorable-word'
    element :age_range, '.t-age-range'
    element :accessibility_requirements, '.t-accessibility'

    element :slot_one_date,     '.t-slot-1-date'
    element :slot_one_period,   '.t-slot-1-period'
    element :slot_two_date,     '.t-slot-2-date'
    element :slot_two_period,   '.t-slot-2-period'
    element :slot_three_date,   '.t-slot-3-date'
    element :slot_three_period, '.t-slot-3-period'

    element :guider, '.t-guider'
  end
end
