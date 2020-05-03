# frozen_string_literal: true

require "rails_helper"

feature "feature_set" do
  let!(:admin_user) { create(:admin_user) }
  let(:artwork) { create(:artwork, :published) }
  let(:keyword) { create(:keyword, name: "Moderne kunst") }
  let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }

  before do
    sign_in admin_user

    visit "/admin/artworks/#{artwork.id}"
  end

  describe "creating feature_set" do
    before do
      click_link "Maak kenmerken set aan"
    end

    it "sets the given values" do
      fill_in "feature_set_material", with: "Hout"
      fill_in "feature_set_price", with: 80909

      click_button "Kenmerken set aanmaken"

      expect(FeatureSet.last.material).to eq "Hout"
      expect(page).to have_content "Hout"
    end

    it "sets all values correctly" do
      fill_in "feature_set_material", with: "Hout"
      fill_in "feature_set_pieces_available", with: 700101
      fill_in "feature_set_price", with: 80909
      fill_in "feature_set_sold_per", with: 545
      fill_in "feature_set_size", with: 9999934

      click_button "Kenmerken set aanmaken"

      expect(page).to have_content "Hout"
      expect(page).to have_content 700101
      expect(page).to have_content "€ 80.909,00"
      expect(page).to have_content 545
      expect(page).to have_content 9999934
    end

    it "sets the standard value if no value set" do
      artwork.update! standard_material: "Glas"

      fill_in "feature_set_price", with: 80909

      click_button "Kenmerken set aanmaken"

      within "#feature_set_#{FeatureSet.last.id}" do
        expect(page).to have_content "Glas"
      end
    end

    describe "price validation" do
      it "can be taken from feature_set" do
        artwork.update! standard_price: 0

        fill_in "feature_set_price", with: 80909

        expect { click_button "Kenmerken set aanmaken" }.not_to raise_error
      end

      it "can be taken from artwork" do
        artwork.update! standard_price: 15

        expect { click_button "Kenmerken set aanmaken" }.not_to raise_error
      end
    end
  end

  describe "creating an artwork" do
    before do
      click_link "Nieuw kunstwerk"

      fill_in "artwork_name", with: "Helemaal nieuw"
      fill_in "artwork_description", with: "Hele uitvoerige uitleg"
    end

    it "will create a feature set" do
      fill_in "artwork_feature_sets_price", with: 80909

      click_button "Kunstwerk aanmaken"

      expect(FeatureSet.count).to eq 1
    end

    it "will give an error if no price is set" do
      click_button "Kunstwerk aanmaken"

      expect(page).to have_content "Er is iets fout gelopen. Bent u zeker dat standaard prijs of kenmerken set prijs opgegeven zijn?"
    end

    it "will set the given values" do
      fill_in "artwork_feature_sets_material", with: "Hout"
      fill_in "artwork_feature_sets_pieces_available", with: 700101
      fill_in "artwork_feature_sets_price", with: 80909
      fill_in "artwork_feature_sets_sold_per", with: 545
      fill_in "artwork_feature_sets_size", with: 9999934

      click_button "Kunstwerk aanmaken"
      within "#artwork_#{Artwork.last.id}" do
        click_link "Bekijk"
      end

      expect(page).to have_content "Hout"
      expect(page).to have_content 700101
      expect(page).to have_content "€ 80.909,00"
      expect(page).to have_content 545
      expect(page).to have_content 9999934
    end

    it "sets the standard value if no value set" do
      fill_in "artwork_name", with: "Helemaal nieuw"
      fill_in "artwork_description", with: "Hele uitvoerige uitleg"
      fill_in "artwork_feature_sets_price", with: 80909
      fill_in "artwork_standard_material", with: "Hout"
      fill_in "artwork_standard_sold_per", with: 545
      fill_in "artwork_standard_size", with: 9999934

      click_button "Kunstwerk aanmaken"
      within "#artwork_#{Artwork.last.id}" do
        click_link "Bekijk"
      end

      within "#feature_set_#{FeatureSet.last.id}" do
        expect(page).to have_content "Hout"
        expect(page).to have_content 545
        expect(page).to have_content 9999934
      end
    end

    it "sets the correct total_amount" do
      fill_in "artwork_feature_sets_price", with: 80909
      fill_in "artwork_feature_sets_pieces_available", with: 70

      click_button "Kunstwerk aanmaken"

      within "#artwork_#{Artwork.last.id}" do
        within ".col-total_amount" do
          expect(page).to have_content 70
        end

        click_link "Bekijk"
      end

      click_link "Maak kenmerken set aan"
      fill_in "feature_set_price", with: 80909
      fill_in "feature_set_pieces_available", with: 10
      click_button "Kenmerken set aanmaken"

      within ".row-total_amount" do
        expect(page).to have_content 80
      end
    end
  end
end
