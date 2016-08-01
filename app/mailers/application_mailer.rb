require 'mailgun_headers'

class ApplicationMailer < ActionMailer::Base
  include MailgunHeaders

  default from: 'appointments@pensionwise.gov.uk'

  layout 'mailer'
end
