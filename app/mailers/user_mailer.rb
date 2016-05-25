class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmationEmail.subject
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

  def disableYourAccount user, setting
    @user = user
    @setting = setting
    @disable_url = settings_disable_account_confirmation_url + '?confirmation_code=' + @setting.confirmation_code.to_s
    mail to: @user.email, subject: 'Request for disable your account'
  end
end
