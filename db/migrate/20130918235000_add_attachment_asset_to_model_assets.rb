class AddAttachmentAssetToModelAssets < ActiveRecord::Migration
  def self.up
    change_table :model_assets do |t|
      t.attachment :asset
    end
  end

  def self.down
    drop_attached_file :model_assets, :asset
  end
end
