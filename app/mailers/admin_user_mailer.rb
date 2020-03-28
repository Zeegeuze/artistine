class AdminUserMailer < ApplicationMailer

 def remark_received(admin_user, artwork, remark)
    @admin_user =  admin_user
    @artwork = artwork
    @remark = remark

    mail to: @admin_user.email, subject: "Nieuwe opmerking ontvangen voor #{artwork.name}"
  end
end
