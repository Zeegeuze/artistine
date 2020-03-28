# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminUserMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe "remark_received" do
    let(:admin_user) { create(:admin_user, email: "admin@testuser.be") }
    let(:artwork) { create(:artwork, name: "Naam van dit super kunstwerk", admin_user: admin_user) }
    let(:remark) { create(:remark, body: "Echt een schoon ding!", artwork: artwork) }
    let(:mail) { AdminUserMailer.remark_received(admin_user, artwork, remark) }

    it "renders the headers" do
      expect(mail.subject).to eq("Nieuwe opmerking ontvangen voor #{artwork.name}")
      expect(mail.to).to eq(["admin@testuser.be"])
      expect(mail.from).to eq(["info@artistine.be"])
    end
   
    it "should be adressed to the correct admin_user" do
      admin2 = create(:admin_user, email: "admin2@test.be")

      expect(mail.to.length).to eq(1)
      expect(mail.to.first).to eq("admin@testuser.be")
    end

    # it "should send the email" do
    #   expect { AdminUserMailer.remark_received(admin_user, artwork, remark).deliver_now }.to change(deliveries, :count).from(0).to(1)
    # end

    it "should contain the body of the remark" do
      expect(mail.body.encoded).to have_content("Echt een schoon ding!")
    end

    it "should contain the name of the artwork" do
      expect(mail.body.encoded).to have_content(artwork.name)
    end
  end
end