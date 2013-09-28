class AddModelCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :model_count, :integer
  end
end
