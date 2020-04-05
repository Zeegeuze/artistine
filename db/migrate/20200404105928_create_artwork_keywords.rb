class CreateArtworkKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :artwork_keywords do |t|
      t.belongs_to :keyword
      t.belongs_to :artwork
      t.timestamps
    end
  end
end