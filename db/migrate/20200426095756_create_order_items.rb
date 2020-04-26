class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.integer "artwork_id", null: false
      t.integer "order_id", null: false
      t.integer "qty", default: 1, null: false
      t.decimal "price", precision: 20, scale: 10
      t.integer "color"
      t.string "material"
      t.decimal "size"
      t.timestamps
    end
  end
end
