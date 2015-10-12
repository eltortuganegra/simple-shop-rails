require 'test_helper'


class LoginProcessTest < ActionDispatch::IntegrationTest
  test "Login process with email" do
    # get login page
    get login_path
    assert_response :success, 'User can not load the login page '

    # login user
    lechuck = users(:LeChuck)
    post login_path,
      session: {
        username_or_email: lechuck.email,
        password: 'secret'
      }
    assert_redirected_to user_path lechuck
  end

  test "Login process with username" do
    # get login page
    get login_path
    assert_response :success, 'User can not load the login page '

    # login user
    lechuck = users(:LeChuck)
    post login_path,
      session: {
        username_or_email: lechuck.username,
        password: 'secret'
      }
    assert_redirected_to user_path lechuck
  end
end
