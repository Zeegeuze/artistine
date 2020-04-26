# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:order)).to be_valid
    end

    it "must have an email" do
      expect(build(:order, email: nil)).to have(1).error_on(:email)
    end

    it "must have a first_name" do
      expect(build(:order, first_name: nil)).to have(1).error_on(:first_name)
    end    

    it "must not have a last_name" do
      expect(build(:order, last_name: nil)).to have(1).error_on(:last_name)
    end

    it "must not have a city" do
      expect(build(:order, city: nil)).to have(1).error_on(:city)
    end

    it "must have a zip_code" do
      expect(build(:order, zip_code: nil)).to have(1).error_on(:zip_code)
    end

    it "must have a house_number" do
      expect(build(:order, house_number: nil)).to have(1).error_on(:house_number)
    end    

    it "must not have a street" do
      expect(build(:order, street: nil)).to have(1).error_on(:street)
    end

    it "must not have a payment_reference" do
      expect(build(:order, payment_reference: nil)).to have(1).error_on(:payment_reference)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
