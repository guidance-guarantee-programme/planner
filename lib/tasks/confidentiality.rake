namespace :confidentiality do
  desc 'Process a confidentiality request (REFERENCE=x)'
  task redact: :environment do
    reference       = ENV.fetch('REFERENCE')
    booking_request = BookingRequest.find(reference)
    appointment     = booking_request.appointment

    attributes = {
      name: 'redacted',
      email: 'redacted@example.com',
      phone: '000000000',
      memorable_word: 'redacted',
      date_of_birth: '1950-01-01',
      additional_info: 'redacted'
    }

    ActiveRecord::Base.transaction do
      puts 'Redacting booking request...'
      booking_request.update!(attributes)
      booking_request.activities.where(type: 'AuditActivity').delete_all

      puts 'Redacting appointment...'
      appointment.without_auditing do
        appointment.update!(attributes)
        appointment.audits.delete_all
      end

      puts 'Done!'
    end
  end
end
