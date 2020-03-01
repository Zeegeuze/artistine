# frozen_string_literal: true

require "rails_helper"

feature "admin" do
  let!(:admin_user) { create(:admin_user) }

  describe "login" do
    it "redirects to artwork#index page" do
      artwork = create(:artwork, name: "Super skoon kunstwerkje")
      sign_in admin_user

      expect(page).to have_content("Super skoon kunstwerkje")
    end
  end
end
