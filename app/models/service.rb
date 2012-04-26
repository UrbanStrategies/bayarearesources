class Service < ActiveRecord::Base
  belongs_to :category
  has_and_belongs_to_many :locations
  
  attr_accessible :description, :name
end
