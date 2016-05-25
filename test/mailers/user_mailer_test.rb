require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  test "confirmationEmail" do
    user_pending_confirm = users(:UserPendingConfirm)

    mail = UserMailer.confirmationEmail user_pending_confirm
    assert_equal "Confirmation action required", mail.subject
    assert_equal [user_pending_confirm.email], mail.to
    assert_equal [Rails.configuration.x.notificationEmail], mail.from
    assert_match "Confirm account", mail.body.encoded
  end

  test "Recovery password email" do
    mail = UserMailer.recoveryPassword users(:LeChuck)
    assert_equal "Recovery password", mail.subject
    assert_equal [users(:LeChuck).email], mail.to
    assert_equal [Rails.configuration.x.notificationEmail], mail.from
    assert_match "Recovery password", mail.body.encoded
  end

  test "When lechuck disable his account he must received an email" do
    disableYourAccountMail = UserMailer.disableYourAccount(users(:LeChuck), settings(:LeChuckSettings)).deliver_now
    lechuckEmail = read_fixture('disable_your_account_lechuck')
      .join('')
      .sub!('<%= @user.username %>', users(:LeChuck).username )
      .sub!('<%= @setting.confirmation_code %>', settings(:LeChuckSettings).confirmation_code )
      .sub!('<%= @disable_url %>',
            settings_disable_account_confirmation_url + '?confirmation_code=' + settings(:LeChuckSettings).confirmation_code
      )
    assert_not ActionMailer::Base.deliveries.empty?, 'Email is not delivered'
    assert_equal "Request for disable your account", disableYourAccountMail.subject, 'Subject is not matching'
    assert_equal [users(:LeChuck).email], disableYourAccountMail.to, 'Target email is not matching'
    assert_equal [Rails.configuration.x.notificationEmail], disableYourAccountMail.from, 'Source email is not matching'
    assert disableYourAccountMail.html_part.to_s.gsub(/\r/, '').index(lechuckEmail.to_s), 'Content of email is not matching'
  end

end
