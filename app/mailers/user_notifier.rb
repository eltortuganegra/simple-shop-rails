class UserNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.confirmationEmail.subject
  #
  def confirmationEmail user
    @user = user
    mail to: @user.email,
      subject: 'Confirmation action required'
  end

  def recoveryPassword user
    @user = user
    mail to: @user.email,
        subject: 'Recovery password'
  end
end
