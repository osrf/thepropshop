class RemoveCategory1FromModel < ActiveRecord::Migration
  def change
    remove_column :models, :category_1, :integer
    remove_column :models, :category_2, :integer
    remove_column :models, :category_3, :integer
  end
end
