require 'test_helper'
require 'users_helper'


class SessionsControllerTest < ActionController::TestCase
  include UsersHelper
  setup do
    @lechuck = users(:LeChuck)
  end

  test "should login a confirmed user with username and password" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.username, password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS}
    assert_redirected_to user_path lechuck
  end

  test "should login a confirmed user with email and password" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.email, password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS}
    assert_redirected_to user_path lechuck
  end

  test "not should login an unconfirmed user with email and password" do
    unconfirmed_user = users(:UserPendingConfirm)
    post :create, session: {username_or_email: unconfirmed_user.email, password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS}
    assert_redirected_to login_path
    assert_equal 'You must <a href="' + confirm_account_path + '">confirm the account</a>. Please check your email and look for the confirmation code.',
      flash[:notice],
      'Flash not found: You must <a href="' + confirm_account_path + '">confirm the account</a>. Please check your email and look for the confirmation code.'
  end

  test "not should login if an user is confirmed but password is not valid" do
    lechuck = users(:LeChuck)
    post :create, session: {username_or_email: lechuck.email, password: PASSWORD_VALID_FORMAT_WRONG}
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "not should login if username is not registered" do
    post :create,
      session: {
        username_or_email: USERNAME_VALID_FORMAT_NOT_REGISTERED,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
      }
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "not should login if email is not registered" do
    post :create,
      session: {
        username_or_email: EMAIL_VALID_FORMAT_NOT_REGISTERED,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
      }
    assert_redirected_to login_path
    assert_equal 'The username and password that you entered did not match our records. Please double-check and try again.',
      flash[:notice],
      'Flash not found: The username and password that you entered did not match our records. Please double-check and try again.'
  end

  test "should redirect to user's page if user is logged and try to do a login action" do
    login users(:LeChuck)

    post :create,
      session: {
        username_or_email: @lechuck.email,
        password: PASSWORD_VALID_FORMAT_WRONG
      }

    assert_redirected_to user_path(@lechuck), 'A logged user must be redirected to the own user\'s page.'
  end

  test "should logout a logged user" do
    login users(:LeChuck)
    get :delete
    assert_equal false, session.has_key?(:user), 'User is not logout yet'
  end

  test "should redirect to the root path when user does a logout action" do
    login users(:LeChuck)
    get :delete
    assert_redirected_to root_path, 'User is not redirected to root path'
  end

  test "should save the id if the 'lechuck' user is in to the session variable" do
    login users(:LeChuck)
    assert session[:user][:id] == @lechuck.id, 'Lechuck not found.'
  end

  test "should return true if lechuck is logged" do
    login users(:LeChuck)
    assert @controller.send(:is_user_logged?) , 'Lechuck is not logged!'
  end

  test "should logout to lechuck" do
    login users(:LeChuck)
    get :delete
    assert ! session.has_key?(:user), 'Lechuck is logged yet!'
  end

end
