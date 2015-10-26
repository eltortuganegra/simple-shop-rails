class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if ! session.has_key?(:user_id) || session[:user_id] != @user.id
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      @user.confirmation_code = SecureRandom.uuid
      if @user.save
        UserNotifier.confirmationEmail(@user).deliver_now
        format.html { redirect_to confirm_account_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if session.has_key?(:user_id) && session[:user_id] == @user.id
        if uploaded_picture?
          uploaded_picture = params.require(:user)[:uploaded_picture]
          move_uploaded_pictured_into_default_path uploaded_picture
          @user.avatar_path = '/images/users/avatars/' + uploaded_picture.original_filename
        end

        if ! username_modified? && ! email_modified? && can_the_is_administrator_field_to_be_update? && @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          if username_modified?
            @user.errors.add(:username, 'can not be changed')
          end
          if email_modified?
            @user.errors.add(:email, 'can not be changed')
          end
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      format.html { render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false) }
      format.json { head :no_content }
    end
  end

  # GET /confirm_account
  def confirm_account
    @user = User.new
    if params.has_key?(:confirmation_code)
      @user.confirmation_code = params[:confirmation_code]
    end
  end

  # POST /confirm_account
  def validate_confirm_account
    respond_to do |format|
      if params[:user].present? && params[:user][:confirmation_code].present?
        @user = User.find_by confirmation_code: params[:user][:confirmation_code]

        if @user
            @user.confirmation_code = nil
            if @user.save(validate: false)
              format.html { redirect_to login_path, notice: 'Account was successfully validated! Please login with your data.' }
              format.json { render :show, status: :ok, location: @user }
            else
              @user.errors.add(:confirmation_code, 'has not been validated. Please try again.')
              format.html { render :confirm_account }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        else
          @user = User.new
          @user.errors.add(:confirmation_code, 'not found.')
          format.html { render :confirm_account }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        @user = User.new
        @user.errors.add(:confirmation_code, 'is empty.')
        format.html { render :confirm_account }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /login
  def login
    @user = User.new
    if is_user_loggin?
      redirect_to user_path session[:user_id]
    else
      @username_or_email = (session.has_key? (:username_or_email)) ?
        session[:username_or_email] :
        ''
      session.delete(:username_or_email)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_administrator)
    end

    def username_modified?
      @user.username != user_params[:username]
    end

    def email_modified?
      @user.email != user_params[:email]
    end

    def is_administrator_modified?
      @user.is_administrator != user_params[:is_administrator]
    end

    def can_the_is_administrator_field_to_be_update?
      ! is_administrator_modified? || is_administrator_modified? && @user.is_administrator
    end

    def is_user_loggin?
      session.has_key? :user_id
    end

    def uploaded_picture?
      params.required(:user).has_key?(:uploaded_picture)
    end

    def move_uploaded_pictured_into_default_path uploaded_picture
      File.open(
        Rails.root.join('public', 'images', 'users', 'avatars', uploaded_picture.original_filename),
        'wb'
      ) do |file|
        file.write(uploaded_picture.read)
      end
    end

end
