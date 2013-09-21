class RemoveFnameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fname, :string
  end
end
