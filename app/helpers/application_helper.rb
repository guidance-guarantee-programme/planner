module ApplicationHelper
  def guard_missing_location(object, attribute)
    object.public_send(attribute)
  rescue
    content_tag(:span, 'Missing', title: object.try(:location_id))
  end

  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-3')
    super(objects, options)
  end

  def booking_location_options
    location_ids = BookingRequest.distinct.pluck(:booking_location_id)

    location_ids.map do |id|
      location = BookingLocations.find(id)
      [location.name, location.id]
    end.sort_by(&:first)
  end

  def location_options(booking_location)
    FlattenedLocationMapper.map(booking_location).sort_by(&:first)
  end
end
