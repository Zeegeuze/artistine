# frozen_string_literal: true

require "rails_helper"

feature "remark" do
  let!(:admin_user) { create(:admin_user) }

  describe "index" do
    let(:artwork) { create(:artwork, name: "Super skoon kunstwerkje") }
    let!(:remark) { create(:remark, body: "Simpelweg adembenemend", artwork: artwork) }

    before do
      sign_in admin_user
      click_link "Opmerkingen"
    end
 
    it "shows the artwork with remark" do
      within "#main_content" do
        expect(page).to have_content("Super skoon kunstwerkje")
        expect(page).to have_content("Simpelweg adembenemend")
      end
    end

    it "only shows artwork with remark" do
      artwork_without_remark = create(:artwork, name: "Nie zo schoon kunstwerkje zonder opmerking")

      click_link "Opmerkingen"

      within "#main_content" do
        expect(page).to have_content("Super skoon kunstwerkje")
        expect(page).not_to have_content("Nie zo schoon kunstwerkje zonder opmerking")
      end
    end

    it "removes the remark correctly" do
      remark2 = create(:remark, body: "te houden", artwork: artwork)

      click_link "Opmerkingen"

      within ".remark_#{remark.id}" do
        click_link "Verwijder"
      end

      within "#main_content" do
        expect(page).not_to have_content("Simpelweg adembenemend")
        expect(page).to have_content("te houden")
      end    
    end
  end
end
