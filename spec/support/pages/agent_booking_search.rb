module Pages
  class AgentBookingSearch < SitePrism::Page
    set_url '/agents/booking_requests'

    element :reference, '.t-reference'
    element :submit, '.t-submit'

    elements :booking_requests, '.t-booking-request'
  end
end
