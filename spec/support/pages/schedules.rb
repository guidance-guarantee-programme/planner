module Pages
  class Schedules < SitePrism::Page
    set_url '/schedules'

    element :success, '.alert-success'

    sections :pagination, '.pagination' do
      element :first_page, 'li.first a'
      element :previous_page, 'li.prev a'
      element :next_page, 'li.next_page a'
      element :last_page, 'li.last a'
      element :current_page, 'li.active a'
    end

    sections :schedules, '.t-schedule' do
      element :location, '.t-location'
      element :realtime_availability, '.t-realtime-availability'
      element :clear_future_slots, '.t-clear-future-slots'
    end
  end
end
