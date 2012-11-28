class LocationServiceDeliveryOption < ActiveRecord::Base
  belongs_to :location
  belongs_to :service_delivery_option
  attr_accessible :location_id, :service_delivery_option_id
end
