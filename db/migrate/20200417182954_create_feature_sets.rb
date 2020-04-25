class CreateFeatureSets < ActiveRecord::Migration[6.0]
  def change
    create_table :feature_sets do |t|
      t.belongs_to :artwork
      t.string :color
      t.string :material
      t.integer :pieces_available, default: 1
      t.decimal :price
      t.integer :sold_per, default: 1
      t.decimal :size
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
