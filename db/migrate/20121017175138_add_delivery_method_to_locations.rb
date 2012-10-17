class AddDeliveryMethodToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :delivery_method, :string
  end
end
