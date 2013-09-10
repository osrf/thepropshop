class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.text :description
      t.integer :category_1
      t.integer :category_2
      t.integer :category_3
      t.string :tags

      t.timestamps
    end
  end
end
