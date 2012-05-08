class Organization < ActiveRecord::Base  
  has_many :locations, :dependent => :destroy, :order => :address
  belongs_to :county
  
  geocoded_by :full_address  
  
  attr_accessible :address, :city, :description, :email, :goal_1, :goal_2, :goal_3, :goal_4, :latitude, :longitude, :name, :phone, :population, :website, :zipcode
  
  after_validation :geocode
  
  def full_address
    [address, city, zipcode].compact.join(', ')
  end
end
