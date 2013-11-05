class AddModelDeleteToModel < ActiveRecord::Migration
  def change
    add_column :models, :delete_request, :boolean
  end
end
