class CreateStatusTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table :status_transitions do |t|
      t.belongs_to :appointment, index: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
