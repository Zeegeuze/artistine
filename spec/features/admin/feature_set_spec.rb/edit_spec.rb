# frozen_string_literal: true

require "rails_helper"

feature "feature_set" do
  let!(:admin_user) { create(:admin_user) }
  let(:artwork) { create(:artwork) }
  let(:keyword) { create(:keyword, name: "Moderne kunst") }
  let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }
  let!(:feature_set) { create(:feature_set, artwork: artwork, material: "Hout", price: 5) }

  before do
    sign_in admin_user

    visit "/admin/artworks/#{artwork.id}"
  end
  
  describe "modifying feature_set" do

    before do
      visit "/admin/artworks/#{artwork.id}"
      click_link "Wijzig"
    end

    it "should update the given values" do
      fill_in "feature_set_material", with: "Glas"
      fill_in "feature_set_price", with: 9

      click_button "Kenmerken set updaten"

      within "#feature_set_#{feature_set.id}" do
        expect(page).to have_content "Glas"
        expect(page).to have_content "€ 9,00"
      end
    end

    it "should set the standard value if value is removed" do
      artwork.update! standard_price: 9

      fill_in "feature_set_price", with: nil

      click_button "Kenmerken set updaten"

      within "#feature_set_#{feature_set.id}" do
        expect(page).to have_content "€ 9,00"
      end
    end
  end
end
