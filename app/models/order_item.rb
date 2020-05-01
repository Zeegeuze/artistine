# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :feature_set, inverse_of: :order_items

  validates :qty, presence: true
  validates :price, presence: true
end
