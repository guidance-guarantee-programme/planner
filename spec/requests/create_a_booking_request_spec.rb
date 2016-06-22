require 'rails_helper'

RSpec.describe 'POST /api/v1/booking_requests' do
  scenario 'create a valid booking request' do
    given_the_client_identifies_as_pension_wise
    when_a_valid_booking_request_is_made
    then_the_booking_request_is_created
    and_the_service_responds_with_a_201
    and_the_customer_receives_a_confirmation_email
  end

  def given_the_client_identifies_as_pension_wise
    create(:pension_wise_api_user)
  end

  def when_a_valid_booking_request_is_made
  end

  def then_the_booking_request_is_created
  end

  def and_the_service_responds_with_a_201
  end

  def and_the_customer_receives_a_confirmation_email
  end
end
