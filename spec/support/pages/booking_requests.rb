module Pages
  class BookingRequests < SitePrism::Page
    set_url '/booking_requests'
    set_url_matcher %r{/\z|/booking_requests\z}

    elements :booking_requests, '.t-booking-request'
  end
end
