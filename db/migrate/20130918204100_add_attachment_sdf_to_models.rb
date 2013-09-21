class AddAttachmentSdfToModels < ActiveRecord::Migration
  def self.up
    change_table :models do |t|
      t.attachment :sdf
    end
  end

  def self.down
    drop_attached_file :models, :sdf
  end
end
