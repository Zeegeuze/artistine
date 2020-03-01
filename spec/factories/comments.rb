# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    artwork { Artwork.first || create(:artwork) }
    body { "Vlammende commentaar" }
  end

  trait :with_user do
    user { User.first || create(:user) }
  end
end
