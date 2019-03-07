class CreateScooterStateChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :scooter_state_changes do |t|
      t.integer :scooter_id
      t.string :attr_changed
      t.string :original_value
      t.string :new_value
      t.index :scooter_id
      t.timestamps
    end
  end
end
