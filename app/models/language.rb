class Language < ActiveRecord::Base
  has_and_belongs_to_many :locations, :uniq => true
  attr_accessible :name
  
  # def locations
  #   locations = []
  #   self.organizations.each do |org|
  #     locations << org.locations
  #   end
  #   locations.flatten.uniq
  # end
  
  def results_in_set(locations_set)
    (self.locations & locations_set).try(:size)
  end
end
