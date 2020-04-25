# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }
  let(:artwork) { create(:artwork) }
  let(:keyword) { create(:keyword, name: "Moderne kunst") }
  let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }

  before do
    sign_in admin_user
    click_link "Kunstwerken"
    click_link "Bekijk"
  end

  describe "show page artwork" do
    describe "keywords" do
      it "shows the keyword" do
        expect(page).to have_content "Moderne kunst"
      end

      it "allows to destroy a keyword" do
        within ".row.row-keywords" do
          click_link "Verwijder"
        end

        expect(ArtworkKeyword.count).to be_zero
        expect(page).not_to have_content "Moderne kunst"
      end

      it "redirects to add a keyword" do
        click_button "Bestaande categorie toevoegen"

        expect(page).to have_content "Wijzig Kunstwerk"
      end
    end

    describe "total_amount" do
      it "shows 1 if no feature_set specified (as per default in feature_set" do
        within ".row-total_amount" do
          expect(page).to have_content 1
        end
      end

      it "shows the total amount of all feature_sets" do
        create(:feature_set, artwork: artwork, pieces_available: 3)
        create(:feature_set, artwork: artwork, pieces_available: 4)

        visit "/admin/artworks/#{artwork.id}"

        within ".row-total_amount" do
          expect(page).to have_content 7
        end
      end

      it "shows sold out if total of feature_sets is 0" do
        create(:feature_set, artwork: artwork, pieces_available: 0)

        visit "/admin/artworks/#{artwork.id}"

        within ".row-total_amount" do
          expect(page).to have_content "Uitverkocht"
        end
      end
    end
  end

  describe "feature set" do
    let!(:feature_set) { create(:feature_set, artwork: artwork) }

    describe "set_as_inactive" do
      it "changes status if called" do
        visit "/admin/artworks/#{artwork.id}"

        click_link "Maak inactief"

        expect(page).to have_link "Maak actief"
        expect(artwork.feature_sets.first.active).to be_falsey
      end
    end

    describe "make_active" do
      it "changes status if called" do
        artwork.feature_sets.first.update! active: false

        within '#header' do
          click_link "Kunstwerken"
        end
        click_link "Bekijk"
        click_link "Maak actief"

        expect(page).to have_link "Maak inactief"
        expect(artwork.feature_sets.first.active).to be_truthy
      end
    end
  end
end
