require 'test_helper'
require 'users_helper'

class SiteControllerTest < ActionController::TestCase
  include UsersHelper
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get a link to index" do
    get :index
    assert_select '#toolbar ul li a.index', 1, 'Link to index in the toolbar not found'
  end

  test "When LeChuck is logged must have a link to settings into the toolbar" do
    login users(:LeChuck)
    get :index
    assert_select '#toolbar ul li a[href="' + settings_path + '"]', 1, 'Link to settings in the toolbar not found'
  end

end
