class Model < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :description
  attr_accessible :tags
  attr_accessible :category
  attr_accessible :rating
  attr_accessible :creator
end
