namespace :organisation_lookups do
  desc 'Import organisation lookups'
  task import: :environment do
    OrganisationLookup.populate
  end
end
