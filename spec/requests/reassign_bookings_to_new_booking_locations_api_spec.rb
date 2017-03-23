require 'rails_helper'

RSpec.describe 'PATCH /api/v1/booking_requests' do
  scenario 'reassign child bookings to the specified booking location' do
    with_real_cache do
      perform_enqueued_jobs do
        given_the_client_identifies_as_pension_wise
        and_a_booking_request_belonging_to_a_child_of_hackney_exists
        and_a_booking_request_belonging_to_a_child_of_taunton_exists
        and_the_locations_are_cached
        when_the_client_makes_a_valid_reassignment_request
        then_the_booking_requests_are_correctly_reassigned
        and_they_have_an_associated_reassignment_activity
        and_the_required_cache_entries_are_expired
        and_the_service_responds_with_a_204
      end
    end
  end

  def given_the_client_identifies_as_pension_wise
    create(:pension_wise_api_user)
  end

  def and_a_booking_request_belonging_to_a_child_of_hackney_exists
    @newham_booking_request = create(:hackney_child_booking_request)
  end

  def and_a_booking_request_belonging_to_a_child_of_taunton_exists
    @north_somerset_booking_request = create(:taunton_child_booking_request)
  end

  def and_the_locations_are_cached
    @cache_keys = [
      @newham_booking_request.booking_location_id,
      @newham_booking_request.location_id,
      @north_somerset_booking_request.booking_location_id,
      @north_somerset_booking_request.location_id
    ].map do |cache_key|
      BookingLocations.cache_prefix(cache_key)
    end

    @cache_keys.each do |cache_key|
      BookingLocations.cache.write(cache_key, 'stuff')
    end
  end

  def when_the_client_makes_a_valid_reassignment_request
    valid_payload = {
      'location_id' => @newham_booking_request.location_id,
      'booking_location_id' => @north_somerset_booking_request.booking_location_id
    }

    patch batch_reassign_api_v1_booking_requests_path, params: valid_payload, as: :json
  end

  def then_the_booking_requests_are_correctly_reassigned
    expect(@newham_booking_request.reload.booking_location_id).to eq(
      @north_somerset_booking_request.booking_location_id
    )
  end

  def and_they_have_an_associated_reassignment_activity
    expect(@newham_booking_request.activities.last).to be_a(ReassignmentActivity)
  end

  def and_the_required_cache_entries_are_expired
    @cache_keys.each do |cache_key|
      expect(BookingLocations.cache.fetch(cache_key)).to be_nil
    end
  end

  def and_the_service_responds_with_a_204
    expect(response).to be_no_content
  end

  def with_real_cache
    cache = BookingLocations.cache
    BookingLocations.cache = ActiveSupport::Cache::MemoryStore.new

    yield
  ensure
    BookingLocations.cache = cache
  end
end
