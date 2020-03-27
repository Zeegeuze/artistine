# frozen_string_literal: true

class Remark < ApplicationRecord
  belongs_to :artwork, inverse_of: :remarks
  belongs_to :user, optional: true, inverse_of: :remarks

  validates :body, presence: true
end
