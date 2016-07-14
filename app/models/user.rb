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
end
