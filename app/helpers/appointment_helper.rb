module AppointmentHelper
  def friendly_options(statuses)
    statuses.map { |k, _| [k.titleize, k] }.to_h
  end

  def location_options(booking_location)
    FlattenedLocationMapper.map(booking_location)
  end

  def guider_options(booking_location)
    booking_location.guiders.map do |guider|
      [guider['name'], guider['id']]
    end
  end
end
