class BookingRequestsPreview < ActionMailer::Preview
  def customer
    BookingRequests.customer(
      FactoryBot.create(:hackney_booking_request),
      BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
    )
  end

  def booking_manager
    BookingRequests.booking_manager(
      FactoryBot.create(:booking_manager)
    )
  end

  def email_failure
    BookingRequests.email_failure(
      FactoryBot.create(:hackney_booking_request),
      FactoryBot.create(:hackney_booking_manager)
    )
  end
end
