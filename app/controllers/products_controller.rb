class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :disable, :enable]
  before_action :check_administrator_privilege, only: [:create, :update]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    if uploaded_picture?
      uploaded_picture = params.require(:product)[:uploaded_picture]
      move_uploaded_pictured_into_default_path uploaded_picture
      @product.image_url = '/images/products/' + uploaded_picture.original_filename
    end


    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if uploaded_picture?
      uploaded_picture = params.require(:product)[:uploaded_picture]
      move_uploaded_pictured_into_default_path uploaded_picture
      @product.image_url = '/images/products/' + uploaded_picture.original_filename
    end
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    respond_to do |format|
      format.html { render_404 }
      format.json { head :no_content }
    end
  end

  # PATCH /products/
  def disable
    @product.disabled_at = DateTime.now
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully disable.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @product, notice: 'Product was not successfully disable.' }
        format.json { head :no_content }
      end
    end
  end

  # PATCH /products/
  def enable
    @product.disabled_at = nil
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully enable.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @product, notice: 'Product was not successfully enable.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :id)
    end

    def uploaded_picture?
      params.required(:product).has_key?(:uploaded_picture)
    end

    def move_uploaded_pictured_into_default_path uploaded_picture
      File.open(
        Rails.root.join('public', 'images', 'products', uploaded_picture.original_filename),
        'wb'
      ) do |file|
        file.write(uploaded_picture.read)
      end
    end

    def check_administrator_privilege
        if ! (session.has_key?(:user_id) && session.has_key?(:is_administrator) && session[:is_administrator])
          redirect_to products_path, notice: 'You have not permissions for this operation'
        end
    end
end
