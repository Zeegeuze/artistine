# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    first_name { "Dmitri" }
    last_name { "Utenov" }
    city { "Vogelbek" }
    zip_code { 5003 }
    house_number { 15 }
    street { "Hierstraat" }
    email { "order@example.com" }
  end
end
