class RecoveryPasswordController < ApplicationController
  def index
  end

  def confirm_code
    if ! recovery_password_params.has_key? :username_or_email
      redirect_to recovery_password_path, notice: 'Username or email is not found.'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_password_params
      params.fetch(:recovery_password, {}).permit(:username_or_email)
    end

end
