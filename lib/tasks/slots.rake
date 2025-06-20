namespace :slots do
  desc 'Remove `EXCLUSIONS` from availability'
  task remove_exclusions: :environment do
    BookableSlot.where(date: EXCLUSIONS).destroy_all
  end

  desc 'Reverts BSL availability to normal after 7 days (unbooked)'
  task revert_bsl: :environment do
    BslSlotReverter.new.call
  end
end
