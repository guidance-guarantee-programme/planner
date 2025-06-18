class AddAvailabilityToReportingSummaries < ActiveRecord::Migration[6.1]
  def change
    add_column :reporting_summaries, :eight_week_availability, :boolean, default: false, null: false
    add_column :reporting_summaries, :twelve_week_availability, :boolean, default: false, null: false
  end
end
