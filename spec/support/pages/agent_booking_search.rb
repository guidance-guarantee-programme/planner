module Pages
  class AgentBookingSearch < SitePrism::Page
    set_url '/agents/booking_requests'

    element :reference, '.t-reference'
    element :customer, '.t-customer'
    element :submit, '.t-submit'

    elements :appointments, '.t-appointment'
  end
end
