# Preview all emails at http://localhost:3000/rails/mailers/admin_user_mailer
class AdminUserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_user_mailer/remark_received
  def remark_received
    AdminUserMailer.remark_received
  end

end
