module ApplicationHelper
  def booking_journey_path
    Plek.find('www') + '/en/book-face-to-face'
  end

  def safe_location_name(location_id)
    location = BookingLocations.find(location_id)
    location&.name_for(location_id)
  end

  def guard_missing_location(object, attribute)
    object.public_send(attribute)
  rescue
    content_tag(:span, 'Missing', title: object.try(:location_id))
  end

  def paginate(objects, **options)
    options.reverse_merge!(theme: 'twitter-bootstrap-3')
    super(objects, **options)
  end

  def booking_location_options(current_user)
    location_ids = BookingRequest.distinct.pluck(:booking_location_id)
    location_ids = filter_org_admin_location_ids(location_ids) if current_user.org_admin?

    location_ids.map do |id|
      location = BookingLocations.find(id)
      [location.name, location.id]
    end.sort_by(&:first)
  end

  def location_options(booking_location)
    FlattenedLocationMapper.map(booking_location).sort_by(&:first)
  end

  def agent_options
    User.active.order(:name).select(&:agent?).pluck(:name, :id)
  end

  def postcode_api_key
    ENV.fetch('POSTCODE_API_KEY') { 'iddqd' } # default to test API key
  end

  def filter_org_admin_location_ids(ids)
    # exclude CAS - Drumchapel, Parkhead
    ids - %w(0c686436-de02-4d92-8dc7-26c97bb7c5bb d0cd2b5a-27dc-4d1d-8d3b-d7b93b5afd4a)
  end
end
