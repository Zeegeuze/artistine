# frozen_string_literal: true

class AnswerRemark < ApplicationRecord
  belongs_to :remark, inverse_of: :answer_remarks
  belongs_to :admin_user, inverse_of: :answer_remarks

  validates :body, presence: true
end
