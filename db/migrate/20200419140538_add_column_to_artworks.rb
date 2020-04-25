class AddColumnToArtworks < ActiveRecord::Migration[6.0]
  def change
    rename_column :artworks, :price, :standard_price
    add_column :artworks, :standard_color, :string
    add_column :artworks, :standard_material, :string
    add_column :artworks, :standard_size, :decimal
    add_column :artworks, :standard_sold_per, :integer, default: 1
  end
end
