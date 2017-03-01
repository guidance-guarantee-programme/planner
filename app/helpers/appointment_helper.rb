module AppointmentHelper
  def field_with_errors_wrapper(form, field, klass)
    error_class = form.object.errors[field].any? ? "field_with_errors #{klass}" : klass

    content_tag(:div, class: error_class) { yield }
  end

  def required_label(field = nil)
    content_tag(:span, field.to_s.humanize) +
      content_tag(:span, '*', class: 'text-danger', 'aria-hidden': true) +
      content_tag(:span, 'Required', class: 'sr-only')
  end

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
