# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    artwork { Artwork.first || create(:artwork) }
    order { Order.first || create(:order) }
    qty { 1 }
    price { 15 }
  end
end
