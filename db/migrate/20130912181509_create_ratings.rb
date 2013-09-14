class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :model_id
      t.integer :user_id
      t.float :score

      t.timestamps
    end
  end
end
