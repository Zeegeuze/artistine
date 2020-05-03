# frozen_string_literal: true

FactoryBot.define do
  factory :artwork do
    admin_user { create(:admin_user) }
    name { "Mooie naam" }
    description { "Heel skone beschrijving van een super kunstwerk" }
  end

  trait :with_feature_set do
    feature_sets { [FeatureSet.first || create(:feature_set)] }
  end

  trait :published do
    published { true }
  end
end
