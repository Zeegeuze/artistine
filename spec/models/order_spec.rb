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

    it "must have a last_name" do
      expect(build(:order, last_name: nil)).to have(1).error_on(:last_name)
    end

    it "must have a city" do
      expect(build(:order, city: nil)).to have(1).error_on(:city)
    end

    it "must have a zip_code" do
      expect(build(:order, zip_code: nil)).to have(1).error_on(:zip_code)
    end

    it "must have a house_number" do
      expect(build(:order, house_number: nil)).to have(1).error_on(:house_number)
    end    

    it "must have a street" do
      expect(build(:order, street: nil)).to have(1).error_on(:street)
    end

    it "should have a unique permalink" do
      o1 = create(:order)
      o2 = create(:order) # create, anders is er nog gn permalink

      o2.permalink = o1.permalink
      expect(o2).not_to be_valid
      expect(o2).to have(1).errors_on(:permalink)

      expect {
        o2.save(validate:false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end

  describe "create" do
    it "should have a permalink" do
      expect(create(:order).permalink).not_to be_nil
    end

    it "should have a payment reference" do
      expect(create(:order).payment_reference).not_to be_nil
    end
  end

  describe "save" do
    it "should not alter the permalink" do
      o = create(:order)
      orig = o.permalink

      o.save!
      expect(o.permalink).to eq(orig)
    end

    it "should not alter the payment_reference" do
      o = create(:order)
      orig = o.payment_reference

      o.save!
      expect(o.payment_reference).to eq(orig)
    end
  end
end
