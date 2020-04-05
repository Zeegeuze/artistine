class AddColumnPublishOnHomepageToKeywords < ActiveRecord::Migration[6.0]
  def change
    add_column :keywords, :publish_on_homepage, :boolean, null: false, default: false
  end
end
