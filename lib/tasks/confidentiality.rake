namespace :confidentiality do
  desc 'Process a confidentiality request (REFERENCE=x)'
  task redact: :environment do
    reference = ENV.fetch('REFERENCE')
    Redactor.new(reference).call
  end

  desc 'Redact all records created greater than two years ago'
  task gdpr: :environment do
    Redactor.redact_for_gdpr
  end
end
