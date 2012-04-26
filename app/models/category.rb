class Category < ActiveRecord::Base
  has_many :services, :order => :name, :dependent => :destroy
  
  attr_accessible :description, :name
end
