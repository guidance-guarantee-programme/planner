class BookingRequestsSearchForm
  include ActiveModel::Model

  attr_accessor :reference, :name, :status, :location, :current_user, :page

  def initialize(params = {})
    params[:status] ||= BookingRequest.statuses.first

    super(params)
  end

  def results # rubocop:disable Metrics/AbcSize
    scope = current_user.unfulfilled_booking_requests
    scope = scope.where(id: reference) if reference.present?
    scope = scope.where('booking_requests.name ILIKE ?', "%#{name}%") if name.present?
    scope = scope.where(status: status) if status.present?
    scope = scope.where(location_id: location) if location.present?

    scope.page(page)
  end
end
