class CreateCounties < ActiveRecord::Migration
  def up
    create_table :counties do |t|
      t.string :name
      t.timestamps
    end
    add_column :organizations, :county_id, :integer
    add_column :locations, :county_id, :integer

    add_index :locations, :county_id
    add_index :organizations, :county_id
  end
  
  def down
    drop_table :counties
    remove_column :organizations, :county_id
    remove_column :locations, :county_id
  end
end
