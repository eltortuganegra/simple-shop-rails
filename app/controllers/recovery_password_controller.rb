class RecoveryPasswordController < ApplicationController
  def index
  end

  def confirm_code
    if request.get? || is_username_or_email_parameter_valid?

    else
      redirect_to recovery_password_path, notice: 'Username or email is not found.' + params.inspect
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_password_params
      params.fetch(:recovery_password, {}).permit(:username_or_email)
    end

    def is_username_or_email_parameter_valid?
        does_username_or_email_parameter_exist? && ! is_username_or_email_parameter_void?
    end

    def does_username_or_email_parameter_exist?
        recovery_password_params.has_key? :username_or_email
    end

    def is_username_or_email_parameter_void?
      recovery_password_params[:username_or_email] == ''
    end

end
