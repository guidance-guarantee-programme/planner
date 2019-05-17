module Pages
  class RealtimeBookableSlotsList < SitePrism::Page
    set_url '/locations/{location_id}/realtime_bookable_slot_lists'

    sections :slots, '.t-slot' do
      element :created_at, '.t-created-at'
      element :start_at, '.t-start-at'
      element :guider, '.t-guider'
      element :available, '.t-available'
      element :delete, '.t-delete'
    end

    element :success, '.alert-success'
  end
end
