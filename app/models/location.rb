class Location < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :services
  
  geocoded_by :full_address
    
  attr_accessible :ac_bus_accessible, :address, :bart_accessible, :city, :directions, :email, :fax, :free_parking, :free_street_parking, :hours, :latitude, :longitude, :muni_bus_accessible, :muni_train_accessible, :name, :organization_id, :paid_parking_lot, :parking_fees, :parking_meters, :phone, :public_transportation_stop, :wheelchair_accessible, :zipcode
  
  after_validation :geocode
  
  def full_address
    [address, city, zipcode].compact.join(', ')
  end
end
