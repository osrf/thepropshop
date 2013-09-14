class AddImagesToModels < ActiveRecord::Migration
  def change
    add_column :models, :image_1, :string
    add_column :models, :image_2, :string
    add_column :models, :image_3, :string
    add_column :models, :image_4, :string
    add_column :models, :image_5, :string
  end
end
