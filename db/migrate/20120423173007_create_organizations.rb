class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :city
      t.string :zipcode
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :website
      t.string :email
      t.text :population
      t.text :goal_1
      t.text :goal_2
      t.text :goal_3
      t.text :goal_4

      t.timestamps
    end
  end
end
