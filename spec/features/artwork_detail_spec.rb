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

    it "indicated if total_amount is zero" do
      create(:feature_set, artwork: artwork, pieces_available: 0, active: true)
      visit "/artwork_details/#{artwork.id}"

      expect(page).to have_content ("Helaas is dit product uitverkocht")
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

  describe "feature_sets" do
    it "shows the feature set if there are artworks available" do
      available_feature_set = create(:feature_set, artwork: artwork, pieces_available: 2, active: true, price: 15)
      visit "/artwork_details/#{artwork.id}"

      expect(page).to have_css (".feature_set_#{available_feature_set.id}")
    end

    it "doesn't show any feature_sets if total_amount is zero" do
      sold_out_feature_set = create(:feature_set, artwork: artwork, pieces_available: 0, active: true, price: 15)
      visit "/artwork_details/#{artwork.id}"

      expect(page).not_to have_css (".feature_set_#{sold_out_feature_set.id}")
    end

    it "doesn't show specific feature_set if pieces_available is zero" do
      available_feature_set = create(:feature_set, artwork: artwork, pieces_available: 2, active: true, price: 15)
      sold_out_feature_set = create(:feature_set, artwork: artwork, pieces_available: 0, active: true, price: 15)
      visit "/artwork_details/#{artwork.id}"

      expect(page).to have_css (".feature_set_#{available_feature_set.id}")
      expect(page).not_to have_css (".feature_set_#{sold_out_feature_set.id}")
    end

    it "doesn't show colom if it is filled in in any feature_set" do
      feature_set = create(:feature_set, artwork: artwork, pieces_available: 2, active: true, price: 15)

      visit "/artwork_details/#{artwork.id}"
      expect(page).not_to have_content "Kleur"
    end
  end
end
