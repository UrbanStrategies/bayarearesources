class Category < ActiveRecord::Base
  has_many :services, :order => :name, :dependent => :destroy
  has_many :locations, :through => :services
  
  attr_accessible :description, :name
end
