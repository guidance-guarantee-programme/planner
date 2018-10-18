module Pages
  class RealtimeAvailability < SitePrism::Page
    set_url '/locations/{location_id}/realtime_bookable_slots'

    elements :guiders, '.t-guider'
    elements :slots, '.t-slot'

    element :success, '.t-success'
    element :day, '.fc-agendaDay-button'

    element :ok, '.ok'

    def wait_for_calendar_events
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until page.evaluate_script('jQuery.active').zero?
      end
    end

    def accept_confirmation
      wait_until_ok_visible
      ok.click
    end

    def click_slot(time, guider_name) # rubocop:disable Metrics/MethodLength
      x, y = page.driver.evaluate_script <<-JS
        function() {
          var $calendar = $('.t-calendar');
          var $header = $calendar.find(".fc-resource-cell:contains('#{guider_name}')");
          if ($header.length > 0) {
            var $row = $calendar.find('[data-time="#{time}:00"]');
            return [$header.offset().left + 5, $row.offset().top + 5];
          }
        }();
      JS

      page.driver.click(x, y)
    end
  end
end
