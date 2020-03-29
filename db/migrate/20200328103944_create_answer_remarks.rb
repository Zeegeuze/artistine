class CreateAnswerRemarks < ActiveRecord::Migration[6.0]
  def change
    create_table :answer_remarks do |t|
      t.string :body
      t.belongs_to :remark
      t.belongs_to :admin_user

      t.timestamps
    end
  end
end
