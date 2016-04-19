class CartController< ApplicationController

  def index
  end

  def add
    if ! session.has_key?(:cart)
      session[:cart] = []
    end
    begin
      session[:cart].push(product_quantity_params_to_symbols)
      redirect_to cart_url, :notice =>'Product added!'
    rescue
      redirect_to cart_url, :flash => {:error => 'Product or amount not valid'}
    end
  end

  private
    def product_quantity_params
      params.require(:product_quantity).permit(:product_id, :quantity)
    end

    def product_quantity_params_to_symbols
      return {
       :product_id => Integer(product_quantity_params['product_id']),
       :quantity => Integer(product_quantity_params['quantity'])
      }
    end

    def validation_product_quantity_params

    end
end