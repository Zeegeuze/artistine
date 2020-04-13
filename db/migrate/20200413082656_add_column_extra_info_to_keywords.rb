class AddColumnExtraInfoToKeywords < ActiveRecord::Migration[6.0]
  def change
    add_column :keywords, :extra_info, :text
  end
end
