require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  setup do
    @product = products(:one)
  end
  test "price can not be negative" do
    @product.price = -10;
    assert @product.invalid?
  end

  test "price can not be greather than or equal to 1000000" do
    @product.price = 1000000;
    assert @product.invalid?
  end
end
