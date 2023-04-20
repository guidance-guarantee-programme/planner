module Pages
  class BookingRequests < SitePrism::Page
    set_url '/booking_requests'
    set_url_matcher %r{/\z|/booking_requests(?:.*)\z}

    section :search, '.t-search' do
      element :reference, '.t-reference'
      element :name, '.t-name'
      element :status, '.t-status'
      element :location, '.t-search-location'

      element :submit, '.t-submit'
    end

    sections :booking_requests, '.t-booking-request' do
      element :fulfil, '.t-fulfil'

      element :primary_slot, '.t-primary-slot'
      element :secondary_slot, '.t-secondary-slot'
      element :tertiary_slot, '.t-tertiary-slot'
    end

    element :location, '.t-location'

    sections :growls, '#growls-default .growl' do
      element :title, '.growl-title'
      element :message, '.growl-message'
    end

    element :booking_location_banner, '.t-booking-location-banner'
  end
end
