class AddCategoryToModel < ActiveRecord::Migration
  def change
    add_column :models, :category, :string
  end
end
