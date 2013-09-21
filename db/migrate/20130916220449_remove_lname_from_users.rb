class RemoveLnameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :lname, :string
  end
end
