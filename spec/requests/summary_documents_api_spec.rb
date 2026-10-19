require 'rails_helper'

RSpec.describe 'POST /api/v1/booking_requests/{booking_request_id}/summary_document' do
  scenario 'Unauthorized access' do
    given_the_user_identifies_as(:user) do
      when_an_unauthorized_request_is_made
      then_the_service_responds_with_a_403_status
    end
  end

  scenario 'Successfully creating a summary document' do
    given_the_user_identifies_as(:pension_wise_api_user) do
      and_a_hackney_booking_manager_exists
      and_a_summarisable_appointment_exists
      when_a_summary_document_is_created
      then_an_activity_is_created
      and_the_service_responds_created
    end
  end

  def when_an_unauthorized_request_is_made
    post api_v1_booking_request_summary_document_path(booking_request_id: 123)
  end

  def then_the_service_responds_with_a_403_status
    expect(response).to be_forbidden
  end

  def and_a_hackney_booking_manager_exists
    @booking_manager = create(:hackney_booking_manager)
  end

  def and_a_summarisable_appointment_exists
    @appointment = create(:appointment)
  end

  def when_a_summary_document_is_created
    post api_v1_booking_request_summary_document_path(
      booking_request_id: @appointment.reference,
      params: {
        owner_uid: @booking_manager.uid,
        delivery_method: 'digital'
      },
      as: :json
    )
  end

  def then_an_activity_is_created
    activity = @appointment.activities.find_by(type: 'SummaryDocumentActivity')

    expect(activity).to have_attributes(
      user_id: @booking_manager.id,
      message: 'digital'
    )
  end

  def and_the_service_responds_created
    expect(response).to be_created
  end
end
