class AddSummaryFieldsToReportingSummaries < ActiveRecord::Migration[6.1]
  def change
    add_column :reporting_summaries, :total_slots_created, :integer, null: true
    add_column :reporting_summaries, :total_slots_available, :integer, null: true
  end
end
