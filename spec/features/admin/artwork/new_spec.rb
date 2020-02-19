# frozen_string_literal: true

require "rails_helper"

feature "artwork" do
  let!(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    click_link "Kunstwerken"
    click_link "Nieuwe Kunstwerk"
  end

  describe "new artwork" do
    it "has the correct admin_user" do
      click_button "Create Kunstwerk"

      expect(Artwork.last.admin_user).to eq(admin_user)
    end
  end
end
