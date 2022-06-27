require 'mailgun_headers'

class ApplicationMailer < ActionMailer::Base
  include MailgunHeaders

  helper :email

  default from: 'Pension Wise Appointments <appointments.pensionwise@moneyhelper.org.uk>'

  layout 'mailer'
end
