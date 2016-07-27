class ApplicationMailer < ActionMailer::Base
  default(
    from: 'appointments@pensionwise.gov.uk',
    'X-Mailgun-Variables' => { online_booking: true }.to_json
  )

  layout 'mailer'
end
