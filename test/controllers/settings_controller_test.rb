require 'test_helper'
require 'users_helper'

class SettingsControllerTest < ActionController::TestCase
  include UsersHelper

  test "When LeChuck is logged he must get the settings page" do
    login users(:LeChuck)
    get :index
    assert_response :success
  end

  test "Anomymous users must be redirected to login page" do
    get :index
    assert_redirected_to login_url, 'Anonymous users must not get the setting page.'
  end

  test "LeChuck must can see the link for the confirmation the disable account into the settings disable account" do
    login users(:LeChuck)
    get :disable_account
    assert_select 'a[href="' + settings_disable_account_confirmation_path + '"]', 1, 'Link to the confirmation page for disable the account is not found.'
  end

  test "LeChuck must can see the link for back the setting page into the settings disable account page" do
    login users(:LeChuck)
    get :disable_account
    assert_select '#content a[href="' + settings_path + '"]', 1, 'Link to the confirmation page for disable the account is not found.'
  end

  test "LeChuck must can access to the confirmation page for disable his account" do
    login users(:LeChuck)
    get :disable_account_confirmation
    assert_response :success
  end

  test "LeChuck must can see the form for disable his account" do
    login users(:LeChuck)
    get :disable_account_confirmation
    assert_select 'form[name="disable_account_confirm"]'
  end

  test "When LeChuck send an invalid confirmation code an error is shown" do
    login users(:LeChuck)
    post :disable_account_confirmation,
         settings: {
             confirmation_code: 'invalid code confirmation'
         }
    assert_select '#content p.alert', 1, 'Alert is not found'
  end

end
