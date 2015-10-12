require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  USERNAME_VALID_FORMAT_NOT_REGISTERED = 'imnotregistered'
  EMAIL_VALID_FORMAT_NOT_REGISTERED = 'thisemailsisnotregistered@themonkeyisland.com'
  PASSWORD_VALID_FORMAT_STANDARD_FOR_ALL_USERS = 'secret'
  PASSWORD_VALID_FORMAT_WRONG = 'wrong'
  PASSWORD_VALID_FORMAT_STANDARD_FOR_UPDATE = 'new_password'


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
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
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

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "Not should update an user if username and/or email are changed" do
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

end
