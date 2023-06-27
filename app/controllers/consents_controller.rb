class ConsentsController < ApplicationController
  skip_before_action :authorise!, only: :show

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  def update
    @booking_request = current_user.booking_requests.find(params[:booking_request_id])
    @booking_request.update_attribute(:gdpr_consent, consent) # rubocop:disable Rails/SkipsModelValidations

    redirect_to edit_appointment_path(@booking_request.appointment),
                success: 'The customer research consent was updated'
  end

  def create; end

  def show
    @appointment = Appointment.find_by(booking_request_id: params[:booking_request_id])

    raise ActiveRecord::RecordNotFound unless @appointment.generated_consent_form.attached?

    redirect_to rails_blob_url(@appointment.generated_consent_form, disposition: :attachment)
  end

  private

  def consent
    params[:booking_request][:gdpr_consent]
  end
end
