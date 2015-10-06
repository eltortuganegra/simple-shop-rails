require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "confirmationEmail" do
    user_pending_confirm = users(:UserPendingConfirm)

    mail = UserNotifier.confirmationEmail user_pending_confirm
    assert_equal "Confirmation action required", mail.subject
    assert_equal [user_pending_confirm.email], mail.to
    assert_equal [Rails.configuration.x.notificationEmail], mail.from
    assert_match "Confirm account", mail.body.encoded
  end

end
