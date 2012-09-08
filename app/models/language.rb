class Language < ActiveRecord::Base
  has_and_belongs_to_many :organizations, :uniq => true
  attr_accessible :name
  
  def locations
    locations = []
    self.organizations.each do |org|
      locations << org.locations
    end
    locations.flatten.uniq
  end
end
