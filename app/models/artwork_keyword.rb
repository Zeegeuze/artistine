class ArtworkKeyword < ApplicationRecord
  belongs_to :artwork, inverse_of: :artwork_keywords
  belongs_to :keyword, inverse_of: :artwork_keywords
end
