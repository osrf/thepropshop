class Rating < ActiveRecord::Base
  attr_accessible :model_id
  attr_accessible :user_id
  attr_accessible :score
end
