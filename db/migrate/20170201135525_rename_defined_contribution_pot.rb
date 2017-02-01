class RenameDefinedContributionPot < ActiveRecord::Migration[5.0]
  def change
    rename_column :booking_requests, :defined_contribution_pot, :defined_contribution_pot_confirmed
  end
end
