class RemoveImage5FromModels < ActiveRecord::Migration
  def change
    remove_column :models, :image_5, :string
  end
end
