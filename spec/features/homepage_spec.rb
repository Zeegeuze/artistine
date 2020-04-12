# frozen_string_literal: true

require "rails_helper"

feature "homepage" do
  let(:keyword) { create(:keyword, :on_homepage, name: "Beestenboel") }
  let!(:artwork) { create(:artwork, published: true, name: "Wel gepubliceerd", keywords: [keyword]) }

  describe "homepage" do
    describe "keywords" do
      it "doesn't show keywords which aren't published" do
        create(:keyword, name: "Dooie boel")

        visit "/"

        expect(page).to have_content ("Beestenboel")
        expect(page).not_to have_content ("Dooie boel")
      end

      it "doesn't show keywords without artworks" do
        create(:keyword, :on_homepage, name: "Lege boel")

        visit "/"

        expect(page).to have_content ("Beestenboel")
        expect(page).not_to have_content ("Lege boel")
      end

      it "only shows published artworks if categorie is published" do
        create(:artwork, name: "Niet gepubliceerd")
        
        visit "/"
        
        expect(page).to have_content ("Wel gepubliceerd")
        expect(page).not_to have_content ("Niet gepubliceerd")
      end
    end
  end
end
