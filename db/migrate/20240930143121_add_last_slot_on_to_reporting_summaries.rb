class AddLastSlotOnToReportingSummaries < ActiveRecord::Migration[6.1]
  def change
    add_column :reporting_summaries, :last_slot_on, :date, null: true
  end
end
