class AddTemporaryIdsOnLocationsAndServices < ActiveRecord::Migration
  def change
    add_column :services, :service_id, :integer
    add_column :locations, :location_id, :integer
  end
end
