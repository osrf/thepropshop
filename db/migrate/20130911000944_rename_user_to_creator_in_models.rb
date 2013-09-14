class RenameUserToCreatorInModels < ActiveRecord::Migration
  def change
    rename_column :models, :user, :creator
  end
end
