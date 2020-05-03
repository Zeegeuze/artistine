# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureSet, type: :model do
  describe "validations" do
    it "is valid" do
      expect(build(:feature_set)).to be_valid
    end

    it "has a price" do
      expect(build(:feature_set, price: nil)).to have(1).error_on(:price)
    end
  end

  describe "scopes" do

  end

  describe "instance methods" do

  end

  describe "actions" do

  end
end
