class ChangesController < ApplicationController
  def index
    @audits = AuditPresenter.wrap(
      appointment.audits.reverse,
      booking_location
    )
  end

  private

  def appointment
    @appointment ||= begin
      current_user
        .appointments
        .find_by(booking_request_id: params[:appointment_id])
    end
  end
end
