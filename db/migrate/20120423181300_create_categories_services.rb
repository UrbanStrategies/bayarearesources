class CreateCategoriesServices < ActiveRecord::Migration
  def up
    create_table :categories_services, :id => false do |t|
      t.integer :category_id
      t.integer :service_id
    end
    
    add_index :categories_services, :category_id
    add_index :categories_services, :service_id
  end

  def down
    drop_table :categories_services
  end
end
