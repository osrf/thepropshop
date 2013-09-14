class AddRatingToModels < ActiveRecord::Migration
  def change
    add_column :models, :rating, :float
  end
end
