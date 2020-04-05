# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }
  let(:artwork) { create(:artwork) }
  let(:keyword) { create(:keyword, name: "Moderne kunst") }
  let!(:artwork_keyword) { create(:artwork_keyword, artwork: artwork, keyword: keyword) }
  let!(:keyword2) { create(:keyword, name: "Prehistorische kunst") }

  before do
    sign_in admin_user
    click_link "Kunstwerken"
    click_link "Wijzig"
  end

  describe "edit page artwork" do
    describe "keywords" do
      it "adds the keyword" do
        select "Prehistorische kunst"
        click_button "Kunstwerk updaten"

        expect(artwork.keywords).to contain_exactly(keyword, keyword2)
      end

      it "will only add keyword once" do
        select "Moderne kunst"
        click_button "Kunstwerk updaten"

        expect(artwork.keywords).to contain_exactly(keyword)
      end
    end
  end
end
