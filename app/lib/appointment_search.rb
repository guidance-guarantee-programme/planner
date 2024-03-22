class AppointmentSearch
  def initialize(query)
    @query = query
  end

  def call
    return [] if query.blank?
    return search_by_reference if /\A\d+\Z/.match?(query)

    Appointment
      .joins(:booking_request)
      .where(search_clauses, query: "%#{query}%")
      .order(created_at: :desc)
      .limit(20)
  end

  private

  attr_reader :query

  def search_clauses
    'appointments.name ILIKE :query OR appointments.email ILIKE :query' \
    ' OR booking_requests.data_subject_name ILIKE :query OR booking_requests.email_consent ILIKE :query'
  end

  def search_by_reference
    Appointment.includes(:booking_request).where(booking_requests: { id: query })
  end
end
