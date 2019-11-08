# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }
  
  describe "price shown with €" do
    let!(:artwork) { create(:artwork) }
  
    it "will follow happy path if category available" do
      artwork.update! price: 5

      sign_in admin_user
      click_link "Kunstwerken"

      expect(page).to have_content("€ 5")
    end
  end
end
