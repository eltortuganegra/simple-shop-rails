require 'test_helper'

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
    assert_equal 'You must confirm your account. Please check your email and look for the confirmation code.',
      flash[:notice],
      'Flash not found: You must confirm your account. Please check your email and look for the confirmation code.'
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
