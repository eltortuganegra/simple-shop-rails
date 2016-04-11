require 'test_helper'

class RecoveryPasswordProcessTestTest < ActionDispatch::IntegrationTest
  NEW_PASSWORD = 'new_password'

  test "Recovery password process" do
    get_recovery_path
    post_the_confirm_code
    post_the_confirmation_for_the_new_password
    post_set_new_password

    post recovery_password_set_new_password_path,
      recovery_password: {
        confirm_code: users(:LeChuck).recovery_password_confirmation_code,
        new_password: NEW_PASSWORD,
        new_password_repeat: NEW_PASSWORD,
      }
    assert_redirected_to login_path, recovery_password_set_new_password_path + ' not found'
  end

  def get_recovery_path
    get recovery_password_path
    assert_response :success, recovery_password_path + ' page not found'
  end

  def post_the_confirm_code
    post recovery_password_confirm_code_path,
         recovery_password: {
             username_or_email: users(:LeChuck).username
         }
    assert_response :success, recovery_password_confirm_code_path + ' not found.'
  end

  def post_the_confirmation_for_the_new_password
    post recovery_password_confirm_new_password_path,
         recovery_password: {
             confirm_code: users(:LeChuck).recovery_password_confirmation_code
         }
    assert_response :success, recovery_password_confirm_new_password_path + ' not found'
  end

  def post_set_new_password

  end
end
