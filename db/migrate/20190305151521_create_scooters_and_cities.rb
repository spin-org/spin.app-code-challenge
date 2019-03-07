class CreateScootersAndCities < ActiveRecord::Migration[5.2]
  def change
    create_table :scooters do |t|
      t.string :uid
      t.integer :city_id
      t.float :charge_percent
      t.boolean :under_maintenance, default: false
      t.st_point :lonlat, geographic: true
      t.index :uid, unique: true
      t.index :lonlat, using: :gist
      t.index :city_id
      t.timestamps
    end

    create_table :cities do |t|
      t.string :name
    end
  end
end
