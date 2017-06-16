module Pages
  class Availability < SitePrism::Page
    set_url '/locations/{location_id}/bookable_slots'

    section :calendar, '.t-calendar' do
      elements :events, '.t-event'
    end

    section :availability_modal, '.t-availability-modal' do
      element :title, '.t-title'
      element :am, '.t-am'
      element :pm, '.t-pm'
      element :save, '.t-save'
    end

    def wait_for_calendar_events
      find('.t-calendar-rendered', visible: false)
    end
  end
end
