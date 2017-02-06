class AppointmentsSearchForm
  include ActiveModel::Model

  attr_accessor :page
  attr_accessor :search_term
  attr_accessor :current_user
  attr_accessor :appointment_date

  def results
    scope = current_user.appointments
    scope = search_term_scope(scope)
    scope = scope.where(proceeded_at: date_range) if date_range

    scope.page(page)
  end

  private

  def search_term_scope(scope)
    return scope unless search_term.present?

    if /\A\d+\Z/ === search_term # rubocop:disable Style/CaseEquality
      scope.where(booking_request_id: search_term)
    else
      scope.where('appointments.name ILIKE ?', "%#{search_term}%")
    end
  end

  def date_range
    return unless appointment_date.present?

    first, last = appointment_date.split(' - ').map(&:to_date)

    first.beginning_of_day..last.end_of_day
  end
end
