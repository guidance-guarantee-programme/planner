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
      element :manage, '.t-manage'
      element :availability, '.t-availability'
      element :realtime_availability, '.t-realtime-availability'

      section :summary, '.t-summary' do
        %i(monday tuesday wednesday thursday friday).each do |day|
          element "#{day}_am", ".t-#{day}-am"
          element "#{day}_pm", ".t-#{day}-pm"
        end
      end
    end
  end
end
