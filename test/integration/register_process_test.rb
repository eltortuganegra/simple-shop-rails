require 'test_helper'
require 'users_helper'

class RegisterProcessTest < ActionDispatch::IntegrationTest
  include UsersHelper

  test "Register process" do
    # Get the root path
    get root_path
    assert_response :success, 'User can not get the root page.'

    # get the signup path
    get signup_path
    assert_response :success, 'User can not get the signup path'

    # Send the register form
    post users_path,
      user: {
        username: USERNAME_VALID_FORMAT_NOT_REGISTERED,
        email: EMAIL_VALID_FORMAT_NOT_REGISTERED,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS,
        password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
      }
    assert_redirected_to confirm_account_path, 'User is not redirected to the confirm account'

    # Check if user is registered
    user = User.find_by(email: EMAIL_VALID_FORMAT_NOT_REGISTERED)
    assert_not_nil user, 'User is not in the database'

    # Get the confirmation page
    get confirm_account_path
    assert_response :success

    # Send the confirm account form
    post confirm_account_path,
      user: {
        confirmation_code: user.confirmation_code
      }
    assert_redirected_to login_path

    # check if account is confirmed
    user.reload
    assert_equal nil, user.confirmation_code, 'User has not confirmed the account.'
  end

end
