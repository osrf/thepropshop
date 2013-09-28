class Downloads < ActiveRecord::Base
  attr_accessible :model_id
  attr_accessible :user_id
  attr_accessible :updated_at
end
