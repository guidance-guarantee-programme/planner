class AgentSearchForm
  include ActiveModel::Model

  attr_accessor :reference, :name, :date, :agent, :page

  def results # rubocop:disable Metrics/AbcSize
    scope = Appointment.includes(booking_request: :agent)
    scope = scope.where(booking_requests: { id: reference }) if reference.present?
    scope = scope.where('appointments.name ILIKE ?', "%#{name}%") if name.present?
    scope = scope.where(created_at: date_range) if date_range
    scope = scope.where(booking_requests: { agent_id: agent }) if agent.present?
    scope.reorder(created_at: :desc).page(page)
  end

  private

  def date_range
    return if date.blank?

    first, last = date.split(' - ').map(&:to_date)
    first.beginning_of_day..last.end_of_day
  end
end
