# frozen_string_literal: true

require "rails_helper"

feature "user artwork" do
  let!(:artwork) { create(:artwork, published: true, name: "Wel gepubliceerd") }

  describe "index page artwork" do
    describe "artwork" do
      it "only shows published artworks" do
        unpublished_artwork = create(:artwork, name: "Niet gepubliceerd")
        
        visit "/artwork"
        
        expect(page).to have_content ("Wel gepubliceerd")
        expect(page).not_to have_content ("Niet gepubliceerd")
      end
    end
  end
end
