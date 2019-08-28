class FixBookableSlotDateTimeAttributes < ActiveRecord::Migration[5.2]
  def up
    add_column :bookable_slots, :start_at, :datetime
    add_column :bookable_slots, :end_at, :datetime

    BookableSlot.reset_column_information

    BookableSlot.find_each do |bs|
      bs.start_at = Time.zone.parse("#{bs.date} #{bs.start.dup.insert(2, ':')}")
      bs.end_at   = Time.zone.parse("#{bs.date} #{bs.end.dup.insert(2, ':')}")

      bs.save(validate: false)
    end
  end
end
