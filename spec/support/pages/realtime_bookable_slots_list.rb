module Pages
  class RealtimeBookableSlotsList < SitePrism::Page
    set_url '/locations/{location_id}/realtime_bookable_slot_lists'

    sections :slots, '.t-slot' do
      element :start_at, '.t-start-at'
      element :guider, '.t-guider'
      element :available, '.t-available'
    end
  end
end
