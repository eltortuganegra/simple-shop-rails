class SettingsController < ApplicationController
  before_action :user_must_be_logged

  def index
  end

  def disable_account
  end

  def disable_account_confirmation
    if is_confirmation_code_coming?
      if ! is_confirmation_code_valid?
        flash.now[:alert] = 'Confirmation code not found. Please, review your email and verify your confirmation code.'
      end
    end
  end

  private
    def settings_params
      params.fetch(:settings, {}).permit(:confirmation_code)
    end

    def is_confirmation_code_valid?
      false
    end

    def is_confirmation_code_coming?
      ! settings_params.nil? && ! settings_params[:confirmation_code].nil?
    end
end
