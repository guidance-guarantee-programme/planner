namespace :statuses do
  desc 'Generate `status_transitions` from audits'
  task generate: :environment do
    ActiveRecord::Base.transaction do
      Audited::Audit.find_each do |audit|
        if audit.audited_changes.key?('status') && audit.auditable
          appointment = audit.auditable
          status      = audit.audited_changes['status']

          # Status is scalar for the initial creation
          status = status.is_a?(Array) ? status.last : status

          appointment.status_transitions.create!(
            status: status,
            created_at: audit.created_at,
            updated_at: audit.created_at
          )
        end
      end
    end
  end
end
