require 'test_helper'

class RecoveryPasswordControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should exist a form with name 'recovery_password_form' at /recovery_password" do
    get :index
    assert_select 'form', 1, 'Form with name "recovery_password_form" not found.'
  end

  test "should exist a field with name 'recovery_password[username_or_email]' in the form with name 'recovery_password_form'" do
    get :index
    assert_select 'form[name="recovery_password_form"] input[name="recovery_password[username_or_email]"]', 1, 'Input with name "email_or_username" not found.'
  end

  test "When users send the username or email for recovery the password without data they are redirect to /recovery_password" do
    post :confirm_code
    assert_redirected_to recovery_password_path
  end

  test "When users access to /recovery_password/confirm_code with a GET they must not be redirected" do
    get :confirm_code
    assert_response :success
  end

  test "Show the \"recovery_password_confirmation_code_form\" form at /recovery_password/confirm_code" do
    get :confirm_code
    assert_select 'form[name="recovery_password_confirmation_code_form"]', 1, 'Not form found.'
  end

  test "Show the input \"recovery_password[confirmation_code]\" at /recovery_password/confirm_code" do
    get :confirm_code
    assert_select 'form[name="recovery_password_confirmation_code_form"] input[name="recovery_password[confirmation_code]"]', 1, 'Input with recovery_password[confirmation_code]" not found.'
  end

end
