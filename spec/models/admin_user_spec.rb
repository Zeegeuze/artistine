# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:admin_user)).to be_valid
    end

    it "must have an email" do
      expect(build(:admin_user, email: nil)).to have(1).error_on(:email)
    end

    it "must have a password" do
      expect(build(:admin_user, password: nil)).to have(1).error_on(:password)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
