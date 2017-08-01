class RemoveExcludedSlotsForGuiderDay < ActiveRecord::Migration[5.1]
  def up
    BookableSlot.where(
      date: Date.parse('03/10/2017')..Date.parse('04/10/2017')
    ).delete_all
  end

  def down
    # noop
  end
end
