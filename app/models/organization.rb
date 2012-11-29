class Organization < ActiveRecord::Base  
  has_many :locations, :dependent => :destroy, :order => :address
  belongs_to :county
  has_and_belongs_to_many :users, :uniq => true
  # has_and_belongs_to_many :languages, :uniq => true  

  geocoded_by :full_address  
  
  attr_accessible :address, :city, :description, :email, :latitude, :longitude, :name, :phone, :population, :website, :zipcode, :county_id, :language_ids
  
  after_validation :geocode
  
  def full_address
    [address, city, zipcode].compact.join(', ')
  end
end
