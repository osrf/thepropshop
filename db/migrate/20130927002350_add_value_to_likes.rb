class AddValueToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :value, :boolean
  end
end
