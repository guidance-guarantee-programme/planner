# frozen_string_literal: true
class User < ActiveRecord::Base
  PENSION_WISE_API_PERMISSION = 'pension_wise_api_user'
  BOOKING_MANAGER_PERMISSION  = 'booking_manager'
  ADMINISTRATOR_PERMISSION    = 'administrator'

  include GDS::SSO::User

  serialize :permissions, Array

  has_many :booking_requests,
           -> { order(:created_at).includes(:slots) },
           primary_key: :organisation_content_id,
           foreign_key: :booking_location_id

  has_many :appointments,
           -> { order(proceeded_at: :desc).includes(:booking_request) },
           through: :booking_requests

  alias_attribute :booking_location_id, :organisation_content_id

  def unfulfilled_booking_requests(hidden: false)
    scope = booking_requests
            .includes(:appointment)
            .where(appointments: { booking_request_id: nil })

    hidden ? scope.inactive : scope.active
  end

  def administrator?
    permissions.include?(ADMINISTRATOR_PERMISSION)
  end
end
