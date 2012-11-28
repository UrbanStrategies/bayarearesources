class ServiceDeliveryOption < ActiveRecord::Base
  has_many :location_service_delivery_options
  has_many :locations, :through => :location_service_delivery_options
  attr_accessible :location_id, :name
end