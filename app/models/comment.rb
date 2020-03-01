# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :artwork, inverse_of: :comments
  belongs_to :user, optional: true, inverse_of: :comments

  validates :body, presence: true
end
