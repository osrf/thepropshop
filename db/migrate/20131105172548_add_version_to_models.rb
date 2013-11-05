class AddVersionToModels < ActiveRecord::Migration
  def change
    add_column :models, :version, :integer
  end
end
