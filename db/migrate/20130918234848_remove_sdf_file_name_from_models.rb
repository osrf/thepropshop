class RemoveSdfFileNameFromModels < ActiveRecord::Migration
  def change
    remove_column :models, :sdf_file_name, :string
  end
end
