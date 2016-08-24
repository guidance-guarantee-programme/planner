# frozen_string_literal: true
class User < ActiveRecord::Base
  PENSION_WISE_API_PERMISSION = 'pension_wise_api_user'
  BOOKING_MANAGER_PERMISSION  = 'booking_manager'

  include GDS::SSO::User

  serialize :permissions, Array

  has_many :booking_requests,
           -> { order(:created_at).includes(:slots) },
           primary_key: :organisation_content_id,
           foreign_key: :booking_location_id

  has_many :appointments,
           -> { order(:proceeded_at).includes(:booking_request) },
           through: :booking_requests

  alias_attribute :booking_location_id, :organisation_content_id

  def unfulfilled_booking_requests
    booking_requests
      .includes(:appointment)
      .where(appointments: { booking_request_id: nil })
  end
end
