module Pages
  class Schedule < SitePrism::Page
    set_url '/schedules/new?location_id={location_id}'

    %i(monday tuesday wednesday thursday friday).each do |day|
      element "#{day}_am", ".t-#{day}-am"
      element "#{day}_pm", ".t-#{day}-pm"
    end

    element :submit, '.t-submit'
  end
end
