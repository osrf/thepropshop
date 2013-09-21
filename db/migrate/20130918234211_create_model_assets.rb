class CreateModelAssets < ActiveRecord::Migration
  def change
    create_table :model_assets do |t|
      t.string :type

      t.timestamps
    end
  end
end
