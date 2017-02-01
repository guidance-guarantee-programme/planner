class EditAppointmentForm < SimpleDelegator
  delegate :guiders, to: :booking_location

  delegate :primary_slot, :secondary_slot, :tertiary_slot, to: :booking_request

  def initialize(location_aware_appointment)
    super
  end

  def flattened_locations
    FlattenedLocationMapper.map(booking_location)
  end

  def defined_contribution_pot_confirmed
    booking_request.defined_contribution_pot_confirmed ? 'Yes' : 'Not sure'
  end
end
