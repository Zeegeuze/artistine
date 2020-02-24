class AddColumnAdminIdToArtworks < ActiveRecord::Migration[6.0]
  def change
    add_reference :artworks, :admin_user, foreign_key: true
  end
end
