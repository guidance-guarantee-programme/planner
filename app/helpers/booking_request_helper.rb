module BookingRequestHelper
  def toggle_activation_link(booking_request)
    action = booking_request.active? ? 'hide' : 'show'

    link_to(
      "#{action.capitalize} this Booking Request",
      booking_request,
      method: :patch,
      class: 'btn btn-danger btn-block t-toggle-activation',
      data: {
        confirm: "Are you sure you want to #{action} #{booking_request.name}'s booking request?"
      }
    )
  end
end
