class AgentSearchForm
  include ActiveModel::Model

  attr_accessor :reference
  attr_accessor :name
  attr_accessor :status
  attr_accessor :date
  attr_accessor :agent
  attr_accessor :page

  def results # rubocop:disable Metrics/AbcSize
    scope = BookingRequest.includes(:slots, :agent)
    scope = scope.where(id: reference) if reference.present?
    scope = scope.where('booking_requests.name ILIKE ?', "%#{name}%") if name.present?
    scope = scope.where(status: status) if status.present?
    scope = scope.where(created_at: date_range) if date_range
    scope = scope.where(agent_id: agent) if agent.present?
    scope.reorder(created_at: :desc).page(page)
  end

  private

  def date_range
    return if date.blank?

    first, last = date.split(' - ').map(&:to_date)
    first.beginning_of_day..last.end_of_day
  end
end
