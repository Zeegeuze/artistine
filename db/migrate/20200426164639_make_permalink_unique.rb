class MakePermalinkUnique < ActiveRecord::Migration[6.0]
  def change
    add_index :orders, :permalink, unique: true
  end
end
