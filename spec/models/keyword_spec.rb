require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe "validations" do
    it "is valid" do
      expect(build(:keyword)).to be_valid
    end

    it "has a name" do
      expect(build(:keyword, name: nil)).to have(1).error_on(:name)
    end

    it "is not standard published on homepage" do
      keyword = create(:keyword)
      expect(keyword.publish_on_homepage).to be_falsey
    end
  end

  describe "scopes" do
    describe "visible_on_homepage" do
      it "only shows published keywords" do
        not_published_keyword = create(:keyword, name: "Niet gepbliceerd")
        published_keyword = create(:keyword, name: "Wel gepbliceerd", publish_on_homepage: true)

        expect(Keyword.visible_on_homepage).to contain_exactly(published_keyword)
      end
    end
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