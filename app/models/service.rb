class Service < ActiveRecord::Base
  belongs_to :category
  has_and_belongs_to_many :locations, :uniq => true
  
  attr_accessible :category_id, :name, :description
  
  def results_in_set(locations_set)
    (self.locations & locations_set).try(:size)
  end
end
