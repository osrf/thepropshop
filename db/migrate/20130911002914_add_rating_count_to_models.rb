class AddRatingCountToModels < ActiveRecord::Migration
  def change
    add_column :models, :rating_count, :integer
  end
end
