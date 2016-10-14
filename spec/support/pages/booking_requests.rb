module Pages
  class BookingRequests < SitePrism::Page
    set_url '/booking_requests'
    set_url_matcher %r{/\z|/booking_requests\z}

    sections :booking_requests, '.t-booking-request' do
      element :fulfil, '.t-fulfil'
    end

    element :location, '.t-location'
  end
end
