class CreateRemarks < ActiveRecord::Migration[6.0]
  def change
    create_table :remarks do |t|
      t.string :body
      t.belongs_to :artwork
      t.belongs_to :user

      t.timestamps
    end
  end
end
