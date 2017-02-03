class AppointmentsSearchForm
  include ActiveModel::Model

  attr_accessor :page
  attr_accessor :search_term
  attr_accessor :current_user

  def results
    scope = current_user.appointments
    scope = search_term_scope(scope)

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
end
