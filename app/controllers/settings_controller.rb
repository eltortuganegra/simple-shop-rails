class SettingsController < ApplicationController
  before_action :user_must_be_logged
  before_action :set_setting, only: [:show, :edit, :update, :destroy, :disable_account_confirmation]


  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def disable_account
  end

  def disable_account_confirmation
    if is_confirmation_code_coming?
      if is_confirmation_code_void?
        flash.now[:alert] = 'Confirmation code is void. Please, review your email and verify your confirmation code.'
      elsif ! is_confirmation_code_valid?
        flash.now[:alert] = 'Confirmation code not found. Please, review your email and verify your confirmation code.'
      else
        redirect_to settings_disable_account_confirmed_url
      end
    else
      @setting.confirmation_code = SecureRandom.uuid
      @setting.save
      UserMailer.disableYourAccount(User.find_by(id: get_logged_user_identifier), @setting).deliver_now
    end
  end

  def disable_account_confirmed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find_by(user_id: session[:user][:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.fetch(:settings, {}).permit(:confirmation_code)
    end

    def is_confirmation_code_void?
      setting_params[:confirmation_code] == ''
    end

    def is_confirmation_code_valid?
      @setting.confirmation_code == setting_params[:confirmation_code]
    end

    def is_confirmation_code_coming?
      ! setting_params.nil? && ! setting_params[:confirmation_code].nil?
    end
end
