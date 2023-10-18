module AppointmentHelper
  def confirmation_type(booking)
    booking.postal_confirmation? ? 'letter' : 'email'
  end

  def field_with_errors_wrapper(form, field, klass, &block)
    error_class = form.object.errors[field].any? ? "field_with_errors #{klass}" : klass

    content_tag(:div, class: error_class, &block)
  end

  def required_label(field = nil)
    content_tag(:span, field.to_s.humanize) +
      content_tag(:span, '*', class: 'text-danger', 'aria-hidden': true) +
      content_tag(:span, 'Required', class: 'sr-only')
  end

  def friendly_options(statuses)
    statuses.map { |k, _| [k.titleize, k] }.to_h
  end

  def guider_options(booking_location, include_inactive: true)
    guiders = booking_location.guiders.map { |guider| [guider.name, guider.id] }.sort_by(&:first)
    guiders = guiders.reject { |tuple| tuple.first.starts_with?('[INACTIVE]') } unless include_inactive
    guiders
  end
end
