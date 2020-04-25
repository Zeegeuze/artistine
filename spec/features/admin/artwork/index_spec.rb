# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }

  describe "index page" do
    describe "price shown with €" do
      let!(:artwork) { create(:artwork) }
    
      it "will follow happy path if category available" do
        artwork.update! standard_price: 5

        sign_in admin_user
        click_link "Kunstwerken"

        expect(page).to have_content("€ 5")
      end
    end

    describe "publishing" do
      describe "artwork not published" do
        let!(:artwork) { create(:artwork, published: false) }

        before do
          sign_in admin_user
          click_link "Kunstwerken"
        end

        it "shows the correct text" do
          within 'tbody' do
            within '.col-published' do
              expect(page).to have_content("Nee")
            end
            within '.col-zichtbaar_onzichtbaar' do
              expect(page).to have_button("Maak zichtbaar")
            end
          end
        end

        it "modifies to not published" do
          click_button "Maak zichtbaar"

          expect(artwork.reload.published).to be_truthy

          within 'tbody' do
            within '.col-published' do
              expect(page).to have_content("Ja")
            end
            within '.col-zichtbaar_onzichtbaar' do
              expect(page).to have_button("Maak onzichtbaar")
            end
          end
        end
      end
      describe "artwork published" do
        let!(:artwork) { create(:artwork, published: true) }

        before do
          sign_in admin_user
          click_link "Kunstwerken"
        end

        it "shows the correct text" do
          within 'tbody' do
            within '.col-published' do
              expect(page).to have_content("Ja")
            end
            within '.col-zichtbaar_onzichtbaar' do
              expect(page).to have_button("Maak onzichtbaar")
            end
          end
        end

        it "modifies to published" do
          click_button "Maak onzichtbaar"

          expect(artwork.reload.published).to be_falsey

          within 'tbody' do
            within '.col-published' do
              expect(page).to have_content("Nee")
            end
            within '.col-zichtbaar_onzichtbaar' do
              expect(page).to have_button("Maak zichtbaar")
            end
          end
        end
      end
    end
  end
end
