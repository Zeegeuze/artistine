# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    click_link "Kunstwerken"
    click_link "Nieuw kunstwerk"
  end

  describe "new artwork" do
    before do
      fill_in "artwork_name", with: "Naam"
      fill_in "artwork_description", with: "Beschrijving"

      click_button "Kunstwerk aanmaken"
    end

    it "has the correct admin_user" do
      expect(Artwork.last.admin_user).to eq(admin_user)
    end

    it "has the correct name" do
      expect(Artwork.last.name).to eq("Naam")
    end

    it "has the correct description" do
      expect(Artwork.last.description).to eq("Beschrijving")
    end
  end
end
