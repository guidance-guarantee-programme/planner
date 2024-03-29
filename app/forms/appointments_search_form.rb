class AppointmentsSearchForm
  include ActiveModel::Model

  attr_accessor :page, :search_term, :status, :location, :guider, :current_user, :appointment_date,
                :processed, :dc_pot_confirmed

  def results # rubocop:disable Metrics/AbcSize
    scope = current_user.appointments.includes(booking_request: :slots)
    scope = search_term_scope(scope)
    scope = processed_scope(scope)
    scope = dc_pot_scope(scope)
    scope = scope.where(proceeded_at: date_range) if date_range
    scope = scope.where(status: status) if status.present?
    scope = scope.where(location_id: location) if location.present?
    scope = scope.where(guider_id: guider) if guider.present?

    scope.page(page)
  end

  private

  def dc_pot_scope(scope)
    return scope if dc_pot_confirmed.blank?

    scope.where(booking_requests: { defined_contribution_pot_confirmed: dc_pot_confirmed })
  end

  def processed_scope(scope)
    if ActiveRecord::Type::Boolean.new.cast(processed)
      scope.where.not(processed_at: nil)
    else
      scope.where(processed_at: nil)
    end
  end

  def search_term_scope(scope)
    return scope if search_term.blank?

    if /\A\d+\Z/.match?(search_term)
      scope.where(booking_request_id: search_term)
    else
      scope.where('appointments.name ILIKE ?', "%#{search_term}%")
    end
  end

  def date_range
    return if appointment_date.blank?

    first, last = appointment_date.split(' - ').map(&:to_date)

    first.beginning_of_day..last.end_of_day
  end
end
