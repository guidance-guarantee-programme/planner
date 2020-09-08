class ConsentsController < ApplicationController
  def update
    @booking_request = current_user.booking_requests.find(params[:booking_request_id])
    @booking_request.update_attribute(:gdpr_consent, consent) # rubocop:disable Rails/SkipsModelValidations

    redirect_to edit_appointment_path(@booking_request.appointment),
                success: 'The customer research consent was updated'
  end

  private

  def consent
    params[:booking_request][:gdpr_consent]
  end
end
