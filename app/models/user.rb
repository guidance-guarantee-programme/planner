# frozen_string_literal: true

class User < ActiveRecord::Base
  PENSION_WISE_API_PERMISSION = 'pension_wise_api_user'
  BOOKING_MANAGER_PERMISSION  = 'booking_manager'
  ADMINISTRATOR_PERMISSION    = 'administrator'
  ORG_ADMIN_PERMISSION        = 'org_admin'
  AGENT_PERMISSION            = 'agent'
  AGENT_MANAGER_PERMISSION    = 'agent_manager'

  include GDS::SSO::User

  serialize :permissions, Array

  has_many :agent_bookings, class_name: 'BookingRequest', foreign_key: :agent_id

  has_many :booking_requests,
           -> { order(:created_at) },
           primary_key: :organisation_content_id,
           foreign_key: :booking_location_id

  has_many :appointments,
           -> { order(proceeded_at: :desc).includes(:booking_request) },
           through: :booking_requests

  alias_attribute :booking_location_id, :organisation_content_id

  scope :active, -> { where(disabled: false) }

  scope :booking_managers, lambda { |booking_location_id|
    active.where(organisation_content_id: booking_location_id).select(&:booking_manager?)
  }

  def unfulfilled_booking_requests
    booking_requests
      .includes(:appointment)
      .where(appointments: { booking_request_id: nil })
  end

  def administrator?
    has_permission?(ADMINISTRATOR_PERMISSION)
  end

  def booking_manager?
    has_permission?(BOOKING_MANAGER_PERMISSION)
  end

  def agent?
    has_permission?(AGENT_PERMISSION)
  end

  def agent_manager?
    has_permission?(AGENT_MANAGER_PERMISSION)
  end

  def org_admin?
    has_permission?(ORG_ADMIN_PERMISSION)
  end
end
