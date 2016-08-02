class EditAppointmentForm < SimpleDelegator
  delegate :guiders, to: :booking_location

  delegate :primary_slot, :secondary_slot, :tertiary_slot, to: :booking_request

  def initialize(location_aware_appointment)
    super
  end

  def flattened_locations
    FlattenedLocationMapper.map(booking_location)
  end
end
