class AddUserToModels < ActiveRecord::Migration
  def change
    add_column :models, :user, :integer
  end
end
