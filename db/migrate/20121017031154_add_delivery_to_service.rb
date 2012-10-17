class AddDeliveryToService < ActiveRecord::Migration
  def change
    add_column :services, :delivery, :string
  end
end
