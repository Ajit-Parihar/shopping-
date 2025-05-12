class AdminUserMailer < ApplicationMailer
  default from: "Business@gmail.com"
  layout "mailer"
   
  def welcome_email(admin_user)
    @admin_user = admin_user
    # @url  = "http://example.com/login"
    mail(to: @admin_user.email, subject: "Welcome to My Awesome Site")
  end

  def reset_password_instructions(record, token, opts={})
  @token = token
  @resource = record
  @reset_password_url = edit_admin_user_password_url(reset_password_token: @token)
  @subject = "Reset Your Admin User Password"
  mail(to: @resource.email, subject: @subject)
end
end
