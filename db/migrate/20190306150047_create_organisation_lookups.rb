class CreateOrganisationLookups < ActiveRecord::Migration[5.2]
  def change
    create_table :organisation_lookups do |t|
      t.string :organisation, null: false, default: ''
      t.string :location_id, null: false, index: true

      t.timestamps
    end
  end
end
