# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:order)).to be_valid
    end

    describe "unless state draft" do
      it "must have an email" do
        expect(build(:order, state: 1, email: nil)).to have(1).error_on(:email)
      end

      it "must have a first_name" do
        expect(build(:order, state: 1, first_name: nil)).to have(1).error_on(:first_name)
      end    

      it "must have a last_name" do
        expect(build(:order, state: 1, last_name: nil)).to have(1).error_on(:last_name)
      end

      it "must have a city" do
        expect(build(:order, state: 1, city: nil)).to have(1).error_on(:city)
      end

      it "must have a zip_code" do
        expect(build(:order, state: 1, zip_code: nil)).to have(1).error_on(:zip_code)
      end

      it "must have a house_number" do
        expect(build(:order, state: 1, house_number: nil)).to have(1).error_on(:house_number)
      end    

      it "must have a street" do
        expect(build(:order, state: 1, street: nil)).to have(1).error_on(:street)
      end

      it "should have a unique permalink" do
        o1 = create(:order, state: 1)
        o1.save!
        o2 = create(:order, state: 1) # create, anders is er nog gn permalink
        o2.save!

        o2.permalink = o1.permalink
        expect(o2).not_to be_valid
        expect(o2).to have(1).errors_on(:permalink)

        expect {
          o2.save(validate:false)
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end

  describe "save" do
    it "should not alter the permalink" do
      o = create(:order, state: 1)
      o.save!

      orig = o.permalink

      o.save!
      expect(o.permalink).to eq(orig)
    end

    it "should not alter the payment_reference" do
      o = create(:order, state: 1)
      o.save!

      orig = o.payment_reference

      o.save!
      expect(o.payment_reference).to eq(orig)
    end
  end
end
