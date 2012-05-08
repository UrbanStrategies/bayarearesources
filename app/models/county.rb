class County < ActiveRecord::Base
  attr_accessible :name
  has_many :locations
  has_many :organizations
end
