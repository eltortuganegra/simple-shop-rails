require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get a link to index" do
    get :index
    assert_select '#toolbar ul li a.index', 1, 'Link to index in the toolbar not found'
  end

end
