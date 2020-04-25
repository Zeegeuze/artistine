# frozen_string_literal: true

require "rails_helper"

feature "keyword" do
  let!(:admin_user) { create(:admin_user) }
  let(:artwork) { create(:artwork, name: "Super kunstwerk", standard_price: 133345) }
  let(:keyword) { create(:keyword) }
  let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }
  let!(:artwork2) { create(:artwork, name: "Von Gagh imitatie", standard_price: 999978) }

  before do
    sign_in admin_user
    click_link "Categorieën"
  end

  describe "show page" do

    describe "artworks" do
      let!(:artwork_keyword2) { create(:artwork_keyword, artwork: artwork2, keyword: keyword) }

      before do
        click_link "Categorieën"
        click_link "Bekijk"
      end

      it "shows all artworks" do
        expect(page).to have_content "€ 133.345,00"
        expect(page).to have_content "€ 999.978,00"
      end

      it "allows to delete an artwork" do
        within "#artwork_#{artwork.id}" do
          click_link "Verwijder"
        end

        expect(keyword.artworks).to eq [artwork2]
      end

      it "allows to add an artwork" do
        click_button "Voeg kunstwerk toe" do
          expect(page).to have_content "Wijzig Categorie"
        end
      end
    end
  end

  describe "edit page" do
    before do
      click_link "Wijzig"
    end

    describe "artworks" do
      it "shows the artworks connected already" do
        expect(page).to have_content "€ 133.345,00"
      end

      it "adds the artwork" do
        select "Von Gagh imitatie"
        click_button "Categorie updaten"

        expect(keyword.artworks).to contain_exactly(artwork, artwork2)
      end

      it "will only add artwork once" do
        select "Super kunstwerk"
        click_button "Categorie updaten"

        expect(keyword.artworks).to contain_exactly(artwork)
      end
    end
  end
end
