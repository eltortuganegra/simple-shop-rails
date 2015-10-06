# Preview all emails at http://localhost:3000/rails/mailers/user_notifier
class UserNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_notifier/confirmationEmail
  def confirmationEmail
    UserNotifier.confirmationEmail
  end

end
