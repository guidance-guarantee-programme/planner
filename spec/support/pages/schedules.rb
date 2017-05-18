module Pages
  class Schedules < SitePrism::Page
    set_url '/schedules'

    sections :schedules, '.t-schedule' do
      element :location, '.t-location'
      element :summary, '.t-summary'
    end
  end
end
