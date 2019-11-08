# frozen_string_literal: true

require "rails_helper"

describe Artwork do
  describe "validations" do
    it "is valid" do
      expect(create(:artwork)).to be_valid
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end
