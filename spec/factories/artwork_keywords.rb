# frozen_string_literal: true

FactoryBot.define do
  factory :artwork_keyword do
    artwork { Artwork.first || create(:artwork) }
    keyword { Keyword.first || create(:keyword) }
  end
end