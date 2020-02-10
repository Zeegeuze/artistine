class AddColumnPhotoToArtwork < ActiveRecord::Migration[6.0]
  def change
    add_column :artworks, :photo, :string
  end
end
