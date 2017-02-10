class AppointmentsPreview < ActionMailer::Preview
  def customer
    Appointments.customer(
      FactoryGirl.create(:appointment),
      BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
    )
  end
end
