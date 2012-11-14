class Location < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :services, :uniq => true
  has_and_belongs_to_many :languages, :uniq => true
  belongs_to :county
  
  
  acts_as_gmappable :address => :full_address
  geocoded_by :full_address
    
  attr_accessible :ac_bus_accessible, :address, :bart_accessible, :city, :directions, :email, :fax, :free_parking, :free_street_parking, :hours, :latitude, :longitude, :muni_bus_accessible, :muni_train_accessible, :name, :organization_id, :paid_parking_lot, :parking_fees, :parking_meters, :phone, :public_transportation_stop, :wheelchair_accessible, :zipcode, :county_id, :language_ids, :delivery_method
  
  after_validation :geocode
  
  validates :organization_id, :presence => true
  
  def categories
    categories = []
    self.services.each do |service|
      categories << service.category
    end
    categories.uniq
  end
  
  def org_name
    if organization.present?
      self.organization.name
    else
      ''
    end
  end
  
  def full_address
    [address, city, 'CA', zipcode].compact.join(', ')
  end
  
  def gmaps4rails_infowindow    
    string = "<strong>#{self.try(:organization).try(:name)}</strong><br />#{self.address}<br />#{self.city}, CA #{self.zipcode}<br />#{self.phone}<br /><a href='mailto:#{self.email}'>#{self.email}</a><br /><br />"
    if self.services.present?
      Category.all(:order => :name).each do |category|
        if (self.services & category.services).present?
          string += "#{category.name}<ul>"
          category.services.each do |service|
            if self.services.include?(service)
              string += "<li>#{service.name}</li>"
            end
          end
          string += "</ul>"
        end
      end
    end
    return string
  end
end
