require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    lechuck = users(:LeChuck)
    session[:user_id] = lechuck.id
    session[:is_administrator] = lechuck.is_administrator
    assert_difference('Product.count') do
      post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title
      }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { description: @product.description, price: @product.price, title: @product.title }
    assert_redirected_to product_path(assigns(:product))
  end

  test "NOT should destroy product" do
    assert_no_difference 'Product.count' do
      delete :destroy, id: @product
    end
    assert_response 404
  end

  test "should redirec to the product path when a product is disabled" do
    patch :disable, id: @product
    assert_redirected_to product_path @product
  end

  test "should disable the product" do
    patch :disable, id: @product
    product = Product.find(@product.id)
    assert ! product.disabled_at.nil?
  end

  test "should create a product without an image" do
    lechuck = users(:LeChuck)
    session[:user_id] = lechuck.id
    session[:is_administrator] = lechuck.is_administrator
    assert_difference('Product.count', 1, 'Product without image not created') do
      post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title,
      }
    end
  end

  test "should redirect to product page when a product is created without an image" do
    lechuck = users(:LeChuck)
    session[:user_id] = lechuck.id
    session[:is_administrator] = lechuck.is_administrator
      post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title,
      }
    assert_redirected_to product_path(assigns :product), 'Redirection is wrong'
  end

  test "should create a product with an image" do
    lechuck = users(:LeChuck)
    session[:user_id] = lechuck.id
    session[:is_administrator] = lechuck.is_administrator
    assert_difference('Product.count', 1, 'Product with image not created') do
      post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title,
        uploaded_picture: fixture_file_upload('files/default_product.png', 'image/png', :binary)
      }
    end
  end

  test "should redirect to product page when a product is created with an image" do
    lechuck = users(:LeChuck)
    session[:user_id] = lechuck.id
    session[:is_administrator] = lechuck.is_administrator
    post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title,
        uploaded_picture: fixture_file_upload('files/default_product.png', 'image/png', :binary)
      }
    assert_redirected_to product_path(assigns :product), 'Redirection is wrong'
  end

  test "should update a product with an image" do
    patch :update,
      id: @product,
      product: {
        description: @product.description,
        price: @product.price,
        title: @product.title,
        uploaded_picture: fixture_file_upload('files/default_product.png', 'image/png', :binary)
      }
    product = Product.find @product.id
    assert ! product.image_url.nil?, 'Product without an image has not been updated with an image.'
  end

  test "should update to a enable a disabled product" do
    disabledProduct = products(:disabledProduct)
    patch :enable,
      id: disabledProduct,
      product: {
        disabled_at: ''
      }
    product = Product.find disabledProduct.id
    assert product.disabled_at.nil?, 'Disabled product has not can been updated to enable.'
  end

  test "anonymous user should not create a product" do
    assert_no_difference('Product.count') do
      post :create, product: {
        description: @product.description,
        price: @product.price,
        title: @product.title
      }
    end

    assert_redirected_to products_path
  end

end
