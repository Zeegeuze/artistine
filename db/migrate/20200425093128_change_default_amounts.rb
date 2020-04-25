class ChangeDefaultAmounts < ActiveRecord::Migration[6.0]
  def change
    change_column_default :feature_sets, :sold_per, nil
  end
end
