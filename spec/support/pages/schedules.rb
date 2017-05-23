module Pages
  class Schedules < SitePrism::Page
    set_url '/schedules'

    sections :schedules, '.t-schedule' do
      element :location, '.t-location'
      element :manage, '.t-manage'

      section :summary, '.t-summary' do
        %i(monday tuesday wednesday thursday friday).each do |day|
          element "#{day}_am", ".t-#{day}-am"
          element "#{day}_pm", ".t-#{day}-pm"
        end
      end
    end
  end
end
