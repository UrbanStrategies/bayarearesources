class AddLanguagesLocationsTable < ActiveRecord::Migration
  def up
    create_table :languages_locations, :id => false do |t|
      t.integer :language_id
      t.integer :location_id
    end
    add_index :languages_locations, :language_id
    add_index :languages_locations, :location_id
  end

  def down
    drop_table :languages_locations
  end
end
