# frozen_string_literal: true

FactoryBot.define do
  factory :artwork do
    admin_user { create(:admin_user) }
    name { "Mooie naam" }
    description { "Heel skone beschrijving van een super kunstwerk" }
  end
end
