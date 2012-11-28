class CreateServiceDeliveryOptions < ActiveRecord::Migration
  def change
    create_table :service_delivery_options do |t|
      t.string :name
      t.timestamps
    end
  end
end
