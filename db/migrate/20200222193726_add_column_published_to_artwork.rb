class AddColumnPublishedToArtwork < ActiveRecord::Migration[6.0]
  def change
    add_column :artworks, :published, :boolean, null: false, default: false
  end
end
