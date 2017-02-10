GovukAdminTemplate.environment_style = Rails.env.staging? ? 'preview' : ENV['RAILS_ENV']

GovukAdminTemplate.configure do |c|
  c.app_title = 'Appointment Planner'
  c.show_flash = true
  c.show_signout = true
end
