module Pages
  class AgentBookingPreview < SitePrism::Page
    set_url '/locations/{location_id}/booking_requests/preview'

    element :confirmation, '.t-confirmation'
  end
end
