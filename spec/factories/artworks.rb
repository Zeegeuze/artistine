# frozen_string_literal: true

FactoryBot.define do
  factory :artwork do
    admin_user { create(:admin_user) }
  end
end
