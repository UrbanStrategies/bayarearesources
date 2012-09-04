class Language < ActiveRecord::Base
  has_and_belongs_to_many :organizations, :uniq => true
  attr_accessible :name
end
