require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe "validations" do
    it "is valid" do
      expect(build(:keyword)).to be_valid
    end

    it "has a name" do
      expect(build(:keyword, name: nil)).to have(1).error_on(:name)
    end
  end

  describe "scopes" do
    
  end

  describe "instance methods" do

  end

  describe "actions" do
    describe "deleting" do
      let(:artwork) { create(:artwork) }
      let(:keyword) { create(:keyword) }
      let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }

      before do
        keyword.destroy!
      end

      it "won't delete the artwork" do
        expect(Keyword.count).to be_zero
        expect(Artwork.count).to be 1
      end

      it "deletes the artwork_keyword" do
        expect(ArtworkKeyword.count).to be_zero
      end
    end
  end
end