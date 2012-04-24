class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :organization_id
      t.string :name
      t.string :address
      t.string :city
      t.string :zipcode
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :fax
      t.string :email
      t.text :hours
      t.text :directions
      t.boolean :wheelchair_accessible, :default => false
      t.boolean :bart_accessible, :default => false
      t.boolean :muni_bus_accessible, :default => false
      t.boolean :muni_train_accessible, :default => false
      t.boolean :ac_bus_accessible, :default => false
      t.boolean :free_parking, :default => false
      t.boolean :parking_meters, :default => false
      t.boolean :paid_parking_lot, :default => false
      t.boolean :free_street_parking, :default => false
      t.string :public_transportation_stop
      t.string :parking_fees
      t.timestamps
    end
    add_index :locations, :organization_id
  end
end
