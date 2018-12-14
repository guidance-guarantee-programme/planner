require_relative './production'

Rails.application.configure do
  config.action_mailer.perform_deliveries = ENV['PERFORM_MAILER_DELIVERIES'].present?
end
