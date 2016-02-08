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

  test "When users send a non registered username for recovery the password they are redirect to /recovery_password" do
    post :confirm_code, recovery: {
        username_or_email: 'thisUsernameIsNotRegistered'
    }
    assert_redirected_to recovery_password_path
  end

  test "When users send a non registered email for recovery the password they are redirect to /recovery_password" do
    post :confirm_code, recovery: {
        username_or_email: 'thisEmailIsNotRegistered@themonkeyisland.com'
    }
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

  test "When users send username then a notice is shown" do
    post :confirm_code, recovery_password: {
        username_or_email: users(:LeChuck).username
    }
    assert_select '#notice', 1, 'Notice not found.'
  end

  test "When users send email then a notice is shown" do
    post :confirm_code, recovery_password: {
        username_or_email: users(:LeChuck).email
    }
    assert_select '#notice', 1, 'Notice not found.'
  end

  test "When users send a valid confirmation code by query string redirect to confirm_new_password" do
    elaine = users(:Elaine_Marley)
    elaine.recovery_password_confirmation_code = SecureRandom.uuid
    elaine.save
    get :confirm_code, {:confirmation_code => elaine.recovery_password_confirmation_code }
    assert_redirected_to recovery_password_confirm_new_password_path
  end

  test "When users send a invalid confirmation code by query string then redirect to confirm_code page" do
    elaine = users(:Elaine_Marley)
    elaine.recovery_password_confirmation_code = SecureRandom.uuid
    elaine.save
    get :confirm_new_password, {'confirmation_code': elaine.recovery_password_confirmation_code + 'not match'}
    assert_redirected_to recovery_password_confirm_code_path
  end

end
