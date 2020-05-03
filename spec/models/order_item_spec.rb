# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:order_item)).to be_valid
    end

    it "must have a qty" do
      expect(build(:order_item, qty: nil)).to have(1).error_on(:qty)
    end

    it "must have a price" do
      expect(build(:order_item, price: nil)).to have(1).error_on(:price)
    end    

    it "must have an feature_set" do
      expect(build(:order_item, feature_set: nil)).to have(1).error_on(:feature_set)
    end

    it "must have an order" do
      expect(build(:order_item, order: nil)).to have(1).error_on(:order)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
