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

end
