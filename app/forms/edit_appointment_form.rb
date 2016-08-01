class EditAppointmentForm
  include ActiveModel::Model

  ATTRIBUTES = %i(
    id
    reference
    booking_location
    booking_request
  ).freeze

  EDITABLE_ATTRIBUTES = %i(
    name
    email
    phone
    location_id
    guider_id
  ).freeze

  attr_writer(*EDITABLE_ATTRIBUTES)

  delegate(*ATTRIBUTES, to: :location_aware_appointment)

  delegate :guiders, to: :booking_location

  delegate :primary_slot, :secondary_slot, :tertiary_slot, to: :booking_request

  def initialize(location_aware_appointment, params)
    @location_aware_appointment = location_aware_appointment

    normalise_time(params)
    super(params)
  end

  def proceeded_at
    @proceeded_at ||= location_aware_appointment.proceeded_at

    Time.zone.parse(@proceeded_at.to_s)
  end

  def flattened_locations
    FlattenedLocationMapper.map(booking_location)
  end

  def update
    location_aware_appointment.update(
      name: name,
      email: email,
      phone: phone,
      guider_id: guider_id,
      location_id: location_id,
      proceeded_at: proceeded_at
    )
  end

  # memoized readers to use `params` when present
  EDITABLE_ATTRIBUTES.each do |attribute|
    class_eval <<~EORUBY, __FILE__, __LINE__ + 1
      def #{attribute}
        @#{attribute} ||= location_aware_appointment.#{attribute}
      end
    EORUBY
  end

  private

  def normalise_time(params)
    date   = params.delete('proceeded_at')
    hour   = params.delete('proceeded_at(4i)')
    minute = params.delete('proceeded_at(5i)')

    @proceeded_at = "#{date} #{hour}:#{minute}" if date && hour && minute
  end

  attr_reader :location_aware_appointment
end
