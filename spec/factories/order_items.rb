# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    feature_set { FeatureSet.first || create(:feature_set) }
    order { Order.first || create(:order) }
    qty { 1 }
    price { 15 }
  end
end
