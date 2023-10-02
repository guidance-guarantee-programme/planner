class ChangesController < ApplicationController
  def index
    @audits = AuditPresenter.wrap(appointment.own_and_associated_audits.reverse, booking_location(appointment))
  end

  private

  def booking_location(appointment)
    super(location_id: appointment.location_id)
  end

  def appointment
    @appointment ||= begin
      scope = if current_user.agent? || current_user.agent_manager?
                Appointment
              else
                current_user.appointments
              end

      scope.find_by(booking_request_id: params[:appointment_id])
    end
  end
end
