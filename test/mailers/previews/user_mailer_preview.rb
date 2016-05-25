# Preview all emails at http://localhost:3000/rails/mailers/user_notifier
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_notifier/confirmationEmail
  def confirmationEmail
    UserMailer.confirmationEmail
  end

end
