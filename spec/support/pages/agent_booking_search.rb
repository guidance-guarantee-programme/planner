module Pages
  class AgentBookingSearch < SitePrism::Page
    set_url '/agents/booking_requests'

    elements :booking_requests, '.t-booking-request'
  end
end
