require 'test_helper'
require File.dirname(__FILE__) + '/users_controller_test'

class SessionsControllerTest < ActionController::TestCase
  test "should login a confirmed user with username and password" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.username, password: 'secret'}
    assert_redirected_to user_path lechuck
  end

  test "should login a confirmed user with email and password" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.email, password: 'secret'}
    assert_redirected_to user_path lechuck
  end

  test "not should login an unconfirmed user with email and password" do
    unconfirmed_user = users(:UserPendingConfirm)
    post :create, session: {username_or_email: unconfirmed_user.email, password: 'secret'}
    assert_redirected_to login_path
    assert_equal 'You must <a href="' + confirm_account_path + '">confirm your account</a>. Please check your email and look for the confirmation code.',
      flash[:notice],
      'Flash not found: You must <a href="' + confirm_account_path + '">confirm your account</a>. Please check your email and look for the confirmation code.'
  end

  test "not should login if an user is confirmed but password is not valid" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.email, password: 'this-password-is-not-for-lechuck'}
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "not should login if username is not registered" do
    post :create,
      session: {
        username_or_email: UsersControllerTest::USERNAME_VALID_FORMAT_NOT_REGISTERED,
        password: UsersControllerTest::PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
      }
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "not should login if email is not registered" do
    post :create,
      session: {
        username_or_email: UsersControllerTest::EMAIL_VALID_FORMAT_NOT_REGISTERED,
        password: UsersControllerTest::PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
      }
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
