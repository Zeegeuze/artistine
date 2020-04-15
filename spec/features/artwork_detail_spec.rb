# frozen_string_literal: true

require "rails_helper"

feature "artwork_detail" do
  let!(:artwork) { create(:artwork, published: true, name: "Wel gepubliceerd") }

  describe "artwork" do
    it "only shows published artworks" do      
      visit "/artwork_details/#{artwork.id}"
      
      expect(page).to have_content ("Wel gepubliceerd")
    end

    it "won't have show page of not published artworks" do
      unpublished_artwork = create(:artwork, name: "Niet gepubliceerd")

      visit "/artwork_details/#{unpublished_artwork.id}"
      
      expect(page).to have_content ("De gevraagde pagina kon niet gevonden worden")
    end
  end
    
  describe "remarks" do
    let!(:remark) { create(:remark, artwork: artwork, body: "Schoon ding!") }

    before do
      visit "/artwork_details/#{artwork.id}"
    end

    it "shows the remarks" do
      expect(page).to have_content ("Schoon ding!")
    end

    it "shows an answer on a remark" do
      create(:answer_remark, remark: remark, body: "Antwoord op remark")

      visit "/artwork_details/#{artwork.id}"

      expect(page).to have_content ("Antwoord op remark")
    end

    it "allows anyone to leave a comment" do
      fill_in "remark_body", with: "Tweede comment"
      click_button "Opmerking toevoegen"

      expect(page).to have_content ("Tweede comment")
    end
  end
end
