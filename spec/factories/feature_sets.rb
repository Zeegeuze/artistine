# frozen_string_literal: true

FactoryBot.define do
  factory :feature_set do
    artwork { Artwork.first || create(:artwork) }
    price { 15 }
  end
end
