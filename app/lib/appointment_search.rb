class AppointmentSearch
  def initialize(query)
    @query = query
  end

  def call
    return [] if query.blank?
    return search_by_reference if /\A\d+\Z/.match?(query)

    Appointment
      .where('name ILIKE :query OR email ILIKE :query', query: "%#{query}%")
      .order(created_at: :desc)
      .limit(20)
  end

  private

  attr_reader :query

  def search_by_reference
    Appointment.includes(:booking_request).where(booking_requests: { id: query })
  end
end
