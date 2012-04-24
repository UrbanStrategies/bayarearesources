class CreateLocationsServices < ActiveRecord::Migration
  def up
    create_table :locations_services, :id => false do |t|
      t.integer :location_id
      t.integer :service_id
    end
    
    add_index :locations_services, :location_id
    add_index :locations_services, :service_id
  end

  def down
    drop_table :locations_services
  end
end
