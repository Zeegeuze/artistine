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
      
      describe "keywords" do
        let(:keyword) { create(:keyword, name: "Schilderkunst", extra_info: "Alles over schilderkunst") }
        
        before do
          artwork.update! keywords: [keyword]
        end

        describe "with existing keywords search" do
          before do
            visit "/artwork?kw=#{keyword.id}"
          end

          it "shows keyword info after specific search" do
            expect(page).to have_content keyword.name
            expect(page).to have_content keyword.extra_info
          end

          it "only shows artworks from searched keyword" do
            other_keyword = create(:keyword, name: "Moderne kunst")
            other_artwork = create(:artwork, keywords: [other_keyword], name: "Iets anders")

            visit "/artwork?kw=#{keyword.id}"

            expect(page).to have_content "Wel gepubliceerd"
            expect(page).not_to have_content "Iets anders"
          end

          it "doesn't show other keyword info when specific search" do
            other_keyword = create(:keyword, name: "Moderne kunst", extra_info: "Veel blabla")

            visit "/artwork?kw=#{keyword.id}"

            expect(page).to have_content "Alles over schilderkunst"
            expect(page).not_to have_content "Veel blabla"
          end
        end

        describe "with non-existing keyword search" do
          before do
            visit "/artwork?kw=#{Keyword.last.id + 1}"
          end

          it "shows all artworks when" do
            expect(page).to have_content artwork.name
          end

          it "won't show keyword information" do
            expect(page).not_to have_content "Categorie: '"
          end
        end
      end
    end
  end
end
