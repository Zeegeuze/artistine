# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    name { "Handgemaakt" }
  end


  trait :on_homepage do
    publish_on_homepage { true }
  end
end
