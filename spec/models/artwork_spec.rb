# frozen_string_literal: true

require "rails_helper"

RSpec.describe Artwork, type: :model do
  describe "validations" do
    it "is valid" do
      expect(create(:artwork)).to be_valid
    end

    it "must have an admin_user" do
      expect(build(:artwork, admin_user: nil)).to have(1).error_on(:admin_user)
    end

    it "must have a name" do
      expect(build(:artwork, name: nil)).to have(1).error_on(:name)
    end    

    it "must have a description" do
      expect(build(:artwork, description: nil)).to have(1).error_on(:description)
    end
  end

  describe "scopes" do
    describe "published" do
      it "selects the published artworks only" do
        published_artwork = create(:artwork, published: true)
        unpublished_artwork = create(:artwork)

        expect(Artwork.published).to contain_exactly(published_artwork)
      end
    end

    describe "with_keyword" do
      it "selects all articles with specific keyword" do
        keyword_1 = create(:keyword, name: "Eerste")
        keyword_2 = create(:keyword, name: "Tweede")
        artwork_with_first_keyword = create(:artwork, keywords: [keyword_1])
        artwork_with_second_keyword = create(:artwork, keywords: [keyword_2])
        artwork_with_first_and_second_keyword = create(:artwork, keywords: [keyword_1, keyword_2])

        expect(Artwork.with_keyword(keyword_1)).to contain_exactly(artwork_with_first_keyword, artwork_with_first_and_second_keyword)
      end
    end
  end

  describe "instance methods" do
    describe "set_as_published" do
      it "changes status if called" do
        artwork = create(:artwork)

        expect(artwork.published).to be_falsey

        artwork.set_as_published!

        expect(artwork.published).to be_truthy
      end

      describe "remove_published" do
        it "changes status if called" do
          artwork = create(:artwork, published: true)

          expect(artwork.published).to be_truthy

          artwork.remove_published!

          expect(artwork.published).to be_falsey
        end
      end
    end

    describe "total_amount" do
      let!(:artwork) { create(:artwork) }
      it "returns 1 if no feature_sets" do
        expect(artwork.total_amount).to be 1
      end

      it "returns 0 is sum pieces_available is 0" do
        feature_set = create(:feature_set, artwork: artwork, pieces_available: 0)

        expect(artwork.total_amount).to be 0
      end

      it "returns correct amount if various feature_sets" do
        feature_set = create(:feature_set, artwork: artwork, pieces_available: 3)
        feature_set2 = create(:feature_set, artwork: artwork, pieces_available: 4)

        expect(artwork.total_amount).to be 7
      end
    end
  end

  describe "actions" do
    describe "deleting" do
      let(:artwork) { create(:artwork) }
      let(:keyword) { create(:keyword) }
      let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }

      before do
        artwork.destroy!
      end

      it "won't delete the keyword" do
        expect(Artwork.count).to be_zero
        expect(Keyword.count).to be 1
      end

      it "deletes the artwork_keyword" do
        expect(ArtworkKeyword.count).to be_zero
      end
    end
  end
end
