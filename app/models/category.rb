class Category < ActiveRecord::Base
  has_and_belongs_to_many :services
  
  attr_accessible :description, :name
end
