module Pages
  class AdHocBookingPreview < SitePrism::Page
    set_url '/locations/{location_id}/appointments/preview'

    element :first_choice_slot, '.t-first-choice-slot'
    element :confirmation, '.t-confirmation'
    element :guider, '.t-guider'
  end
end
