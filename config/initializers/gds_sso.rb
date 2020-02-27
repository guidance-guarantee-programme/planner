GDS::SSO.config do |config|
  config.user_model = 'User'

  config.oauth_id = ENV['OAUTH_ID']
  config.oauth_root_url = ENV.fetch('OAUTH_ROOT_URL', 'http://localhost:3001')
  config.oauth_secret = ENV['OAUTH_SECRET']

  config.additional_mock_permissions_required = [User::PENSION_WISE_API_PERMISSION]

  config.cache = Rails.cache
end
