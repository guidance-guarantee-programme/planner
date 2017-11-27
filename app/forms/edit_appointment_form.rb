class EditAppointmentForm < SimpleDelegator
  include PostalAddressable

  delegate :primary_slot, :secondary_slot, :tertiary_slot, to: :booking_request

  def initialize(location_aware_appointment)
    super
  end
end
