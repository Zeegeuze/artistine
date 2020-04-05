# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArtworkKeyword, type: :model do
  describe "validations" do
    it "is valid" do
      expect(build(:artwork_keyword)).to be_valid
    end

    it "has an artwork" do
      expect(build(:artwork_keyword, artwork: nil)).to have(1).error_on(:artwork)
    end

    it "has a keyword" do
      expect(build(:artwork_keyword, keyword: nil)).to have(1).error_on(:keyword)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end
end