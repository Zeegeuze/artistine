# frozen_string_literal: true

class Keyword < ApplicationRecord
  has_many :artwork_keywords, inverse_of: :keyword, dependent: :destroy
  has_many :artworks, through: :artwork_keywords

  validates :name, presence: true

  scope :visible_on_homepage, -> { where(publish_on_homepage: true) }
end
