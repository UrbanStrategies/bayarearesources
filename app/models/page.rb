class Page < ActiveRecord::Base
  attr_accessible :body, :name, :sort_order
end
