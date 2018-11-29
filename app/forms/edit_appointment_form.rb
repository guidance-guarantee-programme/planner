class EditAppointmentForm < SimpleDelegator
  include PostalAddressable

  delegate :realtime?, :primary_slot, :secondary_slot, :tertiary_slot, :agent, :consent, to: :booking_request

  def initialize(location_aware_appointment)
    super
  end

  def slots
    Schedule
      .current(location_id)
      .without_appointments
      .realtime
  end
end
