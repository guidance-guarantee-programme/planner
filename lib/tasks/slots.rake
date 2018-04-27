namespace :slots do
  desc 'Remove `EXCLUSIONS` from availability'
  task remove_exclusions: :environment do
    BookableSlot.where(date: EXCLUSIONS).destroy_all
  end
end
