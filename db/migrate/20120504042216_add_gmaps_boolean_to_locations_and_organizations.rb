class AddGmapsBooleanToLocationsAndOrganizations < ActiveRecord::Migration
  def change
    add_column :locations, :gmaps, :boolean
    add_column :organizations, :gmaps, :boolean
  end
end
