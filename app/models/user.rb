# frozen_string_literal: true
class User < ActiveRecord::Base
  PENSION_WISE_API_PERMISSION = 'pension_wise_api_user'
  BOOKING_MANAGER_PERMISSION  = 'booking_manager'

  include GDS::SSO::User

  serialize :permissions, Array
end
