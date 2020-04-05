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
  end
end
