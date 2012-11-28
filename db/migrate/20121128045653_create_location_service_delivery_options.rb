class CreateLocationServiceDeliveryOptions < ActiveRecord::Migration
  def change
    create_table :location_service_delivery_options do |t|
      t.integer :location_id
      t.integer :service_delivery_option_id

      t.timestamps
    end
  end
end
