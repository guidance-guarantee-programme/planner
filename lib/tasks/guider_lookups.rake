namespace :guider_lookups do
  desc 'Import guider lookups'
  task import: :environment do
    GuiderLookup.populate
  end
end
