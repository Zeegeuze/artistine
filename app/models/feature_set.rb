# frozen_string_literal: true

class FeatureSet < ApplicationRecord
  
  belongs_to :artwork, inverse_of: :feature_sets
  
  has_many :order_items, inverse_of: :feature_set
  accepts_nested_attributes_for :order_items

end
