# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Remark, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:remark)).to be_valid
    end

    it "must have a body" do
      expect(build(:remark, body: nil)).to have(1).error_on(:body)
    end

    it "must have an artwork" do
      expect(build(:remark, artwork: nil)).to have(1).error_on(:artwork)
    end    

    it "must not have a user" do
      expect(build(:remark, user: nil)).not_to have(1).error_on(:user)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
