# frozen_string_literal: true
class User < ActiveRecord::Base
  PENSION_WISE_API_PERMISSION = 'pension_wise_api_user'

  include GDS::SSO::User

  serialize :permissions, Array
end
