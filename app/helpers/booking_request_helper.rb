module BookingRequestHelper
  def toggle_activation_link(booking_request, &block)
    action = booking_request.active? ? 'hide' : 'show'

    link_to(
      booking_request,
      method: :patch,
      class: 'btn btn-danger btn-block t-toggle-activation booking-request-show-hide-btn',
      data: {
        confirm: "Are you sure you want to #{action} #{booking_request.name}'s booking request?"
      }
    ) do
      yield action
    end
  end
end
