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
  end
end
