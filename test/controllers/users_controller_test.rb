require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @new_user = User.new(
      username: 'new_user',
      email: 'thisemailsisnotregistered@themonkeyisland.com',
      password: 'secret',
      password_confirmation: 'secret'
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
      post :create, user: { email: @new_user.email, password: 'secret', password_confirmation: 'secret', username: @new_user.username }

    end

    assert_redirected_to user_path(assigns(:user))
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
    patch :update, id: @user, user: { email: @user.email,  password: 'secret2', password_confirmation: 'secret2', username: @user.username }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "Not should update an user if username and/or email are changed" do
    patch :update, id: @user, user: { email: @new_user.email, password: 'secret2', password_confirmation: 'secret2', username: @new_user.username }
    assert_response :success
    assert_select '#error_explanation ul li', 2
  end

  test "should confirm an user account" do
    pending_user = users(:UserPendingConfirm)
    post :validate_confirm_account, user: { confirmation_code: pending_user.confirmation_code }
    assert_redirected_to '/login'    
  end

end
