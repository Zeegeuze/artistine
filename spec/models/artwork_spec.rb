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
