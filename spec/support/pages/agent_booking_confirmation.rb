module Pages
  class AgentBookingConfirmation < SitePrism::Page
    set_url '/locations/{location_id}/booking_requests/{id}'

    element :reference, '.t-reference'
  end
end
