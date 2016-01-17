require 'test_helper'

class SupportControllerTest < ActionController::TestCase
  test "should get faq" do
    get :faq
    assert_response :success
  end

  test "should get rules" do
    get :rules
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
