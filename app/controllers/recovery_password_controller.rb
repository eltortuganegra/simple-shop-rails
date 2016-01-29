class RecoveryPasswordController < ApplicationController
  def index
  end

  def confirm_code
    if request.post?
      if is_username_or_email_parameter_valid?
        user = get_user_by_username_or_email recovery_password_params[:username_or_email]
        if user
          user.recovery_password_confirmation_code = SecureRandom.uuid
          if user.save
            UserNotifier.recoveryPassword(user).deliver_now
            flash[:notice] = "You have an email."
          end
        else
          redirect_to recovery_password_path, notice: 'Username or email is not found.'
        end
      else
        redirect_to recovery_password_path, notice: 'Username or email is not found.'
      end
    else
      if params.has_key?('confirmation_code') && params[:confirmation_code] != ''
        user = User.find_by recovery_password_confirmation_code: params[:confirmation_code]
        if (user)
          session[:recovery_password_confirmation_code] = params[:recovery_password_confirmation_code]
          redirect_to recovery_password_confirm_new_password_path
        else
          flash[:notice] = "The confirmation code is not valid. Check your mail and confirm your confirmation code."
          redirect_to confirm_code_recovery_password_path
        end
      end
    end
  end

  def confirm_new_password
    if (! recovery_password_params.has_key? :confirmation_code) || recovery_password_params[:confirmation_code] == ''
      redirect_to confirm_code_recovery_password_path, notice: 'Confirmation code is void.'
    end
    @user = User.select('id, recovery_password_confirmation_code').find_by recovery_password_confirmation_code: recovery_password_params[:confirmation_code]
    if @user.nil?
      redirect_to confirm_code_recovery_password_path, notice: 'Confirmation code not found. '
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_password_params
      params.fetch(:recovery_password, {}).permit(:username_or_email, :confirmation_code)
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

    def get_user_by_username_or_email username_or_email
      if is_email? username_or_email
        User.find_by email: username_or_email
      else
        User.find_by username: username_or_email
      end
    end

    def is_email? username_or_email
      username_or_email =~ User::EMAIL_VALID_FORMAT_PATTERN
    end

end
