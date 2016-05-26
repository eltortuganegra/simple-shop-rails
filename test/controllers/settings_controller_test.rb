require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  fixtures :settings

  setup do
    @setting = settings(:one)
  end

  test "Anonymous users should not get edit" do
    get :edit
    assert_redirected_to login_url
  end

  test "LeChuck should get edit" do
    login users(:LeChuck)
    get :edit, id: @setting
    assert_response :success
  end

  test "Anybody should not get setting show" do
    get :show, id: @setting
    assert_redirected_to login_url
  end

  test "Anybody should not get edit" do
    get :edit, id: @setting
    assert_redirected_to login_url
  end

  test "Anonymous users should not update setting" do
    patch :update, id: @setting, setting: { confirmation_code: @setting.confirmation_code }
    assert_redirected_to login_url
  end

  test "LeChuck should update setting" do
    login users(:LeChuck)
    patch :update, id: @setting, setting: { confirmation_code: @setting.confirmation_code }
    assert_redirected_to setting_path(assigns(:setting))
  end

  test "When the anomymous users get settings page they must be redirected to login page" do
    get :edit
    assert_redirected_to login_url, 'Anonymous users must not get the setting page.'
  end

  test "When LeChuck is logged he must can get the settings page" do
    login users(:LeChuck)
    get :edit
    assert_response :success
  end

  test "Lechuck must be see the link for disable his account in the settings page" do
    login users(:LeChuck)
    get :edit
    assert_select '#content a[href="' + settings_disable_account_path + '"]', 1, 'link to disable account page is not found'
  end

  test "LeChuck must can see the link for back the setting page into the settings disable account page" do
    login users(:LeChuck)
    get :disable_account
    assert_select '#content a[href="' + settings_path + '"]', 1, 'Link to the confirmation page for disable the account is not found.'
  end

  test "LeChuck must can see the link for the confirmation for disable his account into the settings disable account" do
    login users(:LeChuck)
    get :disable_account
    assert_select '#content a[href="' + settings_disable_account_confirmation_path + '"]', 1, 'Link to the confirmation page for disable the account is not found.'
  end

  test "When anonymous users get the confirmation page for disable their accounts they are redirect to the login page" do
    get :disable_account_confirmation
    assert_redirected_to login_url, 'Anonymous users must be redirect to the login page'
  end

  test "LeChuck must can access to the confirmation page for disable his account" do
    login users(:LeChuck)
    get :disable_account_confirmation
    assert_response :success
  end

  test "LeChuck must can see the form for the confirmation for disable his account" do
    login users(:LeChuck)
    get :disable_account_confirmation
    assert_select 'form[name="disable_account_confirm"]'
  end

  test "When LeChuck get the confirmation page for disable his account a new confirmation code is created" do
    login users(:LeChuck)
    get :disable_account_confirmation
    assert_not_nil settings(:LeChuckSettings).confirmation_code, 'Confirmation code is not being saved into the database'
  end

  test "When LeChuck send an invalid confirmation code an error is shown" do
    login users(:LeChuck)
    post :disable_account_confirmation,
         settings: {
             confirmation_code: 'invalid code confirmation'
         }
    assert_select '#content p.alert', 1, 'Alert is not found'
  end

  test "When the users introduces a valid confirmation code they are redirected to the page of the disable your account confirmed" do
    login users(:LeChuck)
    get :disable_account_confirmation
    post :disable_account_confirmation,
        settings: {
            confirmation_code: settings(:LeChuckSettings).confirmation_code
        }
    assert_redirected_to settings_disable_account_confirmed_url
  end

end
