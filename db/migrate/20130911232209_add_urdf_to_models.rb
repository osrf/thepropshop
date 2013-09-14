class AddUrdfToModels < ActiveRecord::Migration
  def change
    add_column :models, :urdf, :text
  end
end
