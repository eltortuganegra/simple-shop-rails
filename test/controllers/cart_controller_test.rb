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

  test "Anonymous user add a grog bottle to his cart" do
    post :add, product_quantity: {
        product_id: products(:grogBottle).id,
        quantity: 1
    }
    assert_equal session[:cart][0], {product_id: products(:grogBottle).id, quantity: 1}, 'The grog bottle is not in the GuyBrush\'s cart.'
  end

  test "When users add a product to theirs carts they are redirected to the cart view" do
    post :add, product_quantity: {
        product_id: products(:grogBottle).id,
        quantity: 1
    }
    assert_redirected_to cart_url
  end


  test "When users add a product then if the product_id is not a number an error is loaded in the flash" do
    post :add, product_quantity: {
        product_id: 'XXX',
        quantity: 1
    }
    assert flash.key?('error'), 'Error is not loaded in the flash.'
  end

  test "When users add a product then if the amount is not a number an error is loaded in the flash" do
    post :add, product_quantity: {
        product_id: products(:grogBottle).id,
        quantity: 'X'
    }
    assert flash.key?('error'), 'Error is not loaded in the flash.'
  end

end