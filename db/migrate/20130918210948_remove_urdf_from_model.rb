class RemoveUrdfFromModel < ActiveRecord::Migration
  def change
    remove_column :models, :urdf, :text
  end
end
