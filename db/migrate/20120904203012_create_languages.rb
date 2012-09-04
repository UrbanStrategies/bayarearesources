class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages_organizations, :id => false do |t|
      t.integer :language_id
      t.integer :organization_id
    end
    add_index :languages_organizations, :language_id
    add_index :languages_organizations, :organization_id
    
    create_table :languages do |t|
      t.string :name
      t.timestamps
    end
  end
end
