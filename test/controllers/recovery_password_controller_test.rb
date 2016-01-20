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

  test "should exist a field with name 'email_or_username' in the form with name 'recovery_password_form'" do
    get :index
    assert_select 'form[name="recovery_password_form"] input[name="email_or_username"]', 1, 'Input with name "email_or_username" not found.'
  end

end
