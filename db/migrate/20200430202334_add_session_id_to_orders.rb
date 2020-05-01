class AddSessionIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :session_id, :string
    add_column :orders, :state, :integer, null: false, default: 0
  end
end
