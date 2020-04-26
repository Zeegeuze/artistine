class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :permalink
      t.string :first_name
      t.string :last_name
      t.text :extra_info
      t.string :city
      t.decimal :zip_code
      t.decimal :house_number
      t.string :address_addition
      t.string :street
      t.datetime :ordered_at
      t.string :order_state, default: 0, nil: false
      t.string :payment_reference
      t.datetime :debt_changed_at
      t.string :email
      t.string :received_last_payment_reminder_at
      t.decimal :total_received_payment_reminders, default: 0
      t.timestamps
    end
  end
end
