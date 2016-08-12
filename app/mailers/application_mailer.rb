require 'mailgun_headers'

class ApplicationMailer < ActionMailer::Base
  include MailgunHeaders

  default from: 'Pension Wise Appointments <appointments@pensionwise.gov.uk>'

  layout 'mailer'
end
