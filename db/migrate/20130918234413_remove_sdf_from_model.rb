class RemoveSdfFromModel < ActiveRecord::Migration
  def change
    remove_column :models, :sdf_file_name, :string
    remove_column :models, :sdf_content_type, :string
    remove_column :models, :sdf_file_size, :integer
    remove_column :models, :sdf_updated_at, :datetime
  end
end
