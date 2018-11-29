module Pages
  class AgentBookingPreview < SitePrism::Page
    set_url '/locations/{location_id}/booking_requests/preview'

    element :first_choice_slot, '.t-first-choice-slot'
    element :confirmation, '.t-confirmation'
  end
end
