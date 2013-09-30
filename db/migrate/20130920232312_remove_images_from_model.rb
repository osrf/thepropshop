class RemoveImagesFromModel < ActiveRecord::Migration
  def change
    remove_column :models, :image_1, :string
    remove_column :models, :image_2, :string
    remove_column :models, :image_3, :string
    remove_column :models, :image_4, :string
  end
end
