class ModelAsset < ActiveRecord::Base
  belongs_to :model
  attr_accessible :asset
end
