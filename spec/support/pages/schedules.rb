module Pages
  class Schedules < SitePrism::Page
    set_url '/schedules'

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
    end
  end
end
