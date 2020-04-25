# frozen_string_literal: true

class FeatureSet < ApplicationRecord
  belongs_to :artwork, inverse_of: :feature_sets
end
