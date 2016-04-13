require 'test_helper'

class CartControllerTest < ActionController::TestCase
  test "Get the cart" do
    get :index
    assert_response :success
  end

  test "Get the cart without products" do
    get :index
    assert_select 'p', {:text => 'You have not products.'}, 'The "You have not product." not found'
  end

end