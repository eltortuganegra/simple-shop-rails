require 'test_helper'
require 'users_helper'

class UsersControllerTest < ActionController::TestCase
  include UsersHelper

  setup do
    @user = users(:one)
    @new_user = User.new(
      username: USERNAME_VALID_FORMAT_NOT_REGISTERED,
      email: EMAIL_VALID_FORMAT_NOT_REGISTERED,
      password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS,
      password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS
    )
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create,
        user: { email: @new_user.email,
          password: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS,
          password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS,
          username: @new_user.username
        }
    end
    assert_redirected_to confirm_account_path
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    login @user
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    login @user
    patch :update,
      id: @user,
      user: {
        email: @user.email,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        username: @user.username
      }
    assert_redirected_to user_path(assigns(:user))
  end

  test "Not should update an user if username and/or email are changed" do
    login @user
    patch :update,
      id: @user,
      user: {
        email: @new_user.email,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        username: @new_user.username
      }
    assert_response :success
    assert_select '#error_explanation ul li', 2, 'Must have two errors: user and email.'
  end

  test "should confirm an user account" do
    pending_user = users(:UserPendingConfirm)
    post :validate_confirm_account, user: { confirmation_code: pending_user.confirmation_code }
    assert_redirected_to login_path
  end

  test "should not update another account which the user is not the owner" do
    login users(:LeChuck)
    guybrush = users(:Guybrush_Threepwood)
    post :update,
      id: guybrush.id,
      user: {
        username: guybrush.username,
        email: guybrush.email,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE
      }
    assert_response 403
  end

  test "should not get the update page of another user" do
    login users(:LeChuck)
    guybrush = users(:Guybrush_Threepwood)
    get :edit, id: guybrush
    assert_response 403
  end

  test "not logged user should not destroy its account" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_response 403
  end

  test "logged user should not destroy its account" do
    login users(:LeChuck)
    assert_no_difference 'User.count' do
      delete :destroy, id: users(:LeChuck)
    end
    assert_response 403
  end

  test "logged user should update the avatar of a user" do
    login @user
    patch :update,
      id: @user,
      user: {
        email: @user.email,
        username: @user.username,
        uploaded_picture: fixture_file_upload('files/default_avatar.png', 'image/png', :binary)
      }
    user = User.find @user.id
    assert ! user.avatar_path.nil?, 'The user\'s avatar can not be updated.'
  end

  test "should not show error when update without password" do
    login @user
    patch :update,
      id: @user,
      user: {
        email: @user.email,
        username: @user.username,
        password: '',
        password_confirmation: '',
        uploaded_picture: fixture_file_upload('files/default_avatar.png', 'image/png', :binary)
      }
    assert_select '#error_explanation', 0, 'The div error has been showed.'
  end

  test "should not update is_administrator if user is not an administrator" do
    login @user
    patch :update,
      id: @user,
      user: {
        email: @user.email,
        username: @user.username,
        password: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        password_confirmation: PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE,
        is_administrator: true
      }
    user = User.find @user.id
    assert ! user.is_administrator, 'An user without an administrator profile can no update the is_administrator field.'
  end

  test "An anonymous user should not see the is_administrator field" do
    get :show, id: @user
    assert_select '#is_administrator', 0, 'Administrator field found.'
  end

  test "Add the link 'forget your password?' in login page." do
    get :login
    assert_select 'a[href="' + recovery_password_path + '"]', 1, 'Link to recovery password not found.'
  end

end
