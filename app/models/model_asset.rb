class ModelAsset < ActiveRecord::Base
  belongs_to :model
  has_attached_file :asset
  attr_accessible :asset
end
