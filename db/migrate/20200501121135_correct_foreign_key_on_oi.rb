class CorrectForeignKeyOnOi < ActiveRecord::Migration[6.0]
  def change
    rename_column :order_items, :artwork_id, :feature_set_id
  end
end
