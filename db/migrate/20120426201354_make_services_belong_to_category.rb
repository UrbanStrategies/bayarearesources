class MakeServicesBelongToCategory < ActiveRecord::Migration
  def up
    add_column :services, :category_id, :integer
    drop_table :categories_services
  end

  def down
    remove_column :services, :category_id
    create_table :categories_services, :id => false do |t|
      t.integer :category_id
      t.integer :service_id
    end
    
    add_index :categories_services, :category_id
    add_index :categories_services, :service_id  
  end
end
