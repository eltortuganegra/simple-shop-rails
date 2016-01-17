require 'test_helper'

class PoliciesControllerTest < ActionController::TestCase
  test "should get terms_of_service" do
    get :terms_of_service
    assert_response :success
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
  end

  test "should get cookies_terms" do
    get :cookies_terms
    assert_response :success
  end

end
