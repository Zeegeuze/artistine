# frozen_string_literal: true

require "rails_helper"

describe Artwork do
  describe "validations" do
    it "is valid" do
      expect(create(:artwork)).to be_valid
    end

    it "must have an admin_user" do
      expect(build(:artwork, admin_user: nil)).to have(1).error_on(:admin_user)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
