class CreateInventoryItems < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_items do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :ebay_id, null: false, unique: true
      t.string :image_url
      t.string :condition, null: false
      t.timestamps
    end
  end
end
