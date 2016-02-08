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
            session[:recovery_password_confirmation_code] = user.recovery_password_confirmation_code
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
          session[:recovery_password_confirmation_code] = params[:confirmation_code]
          redirect_to recovery_password_confirm_new_password_path
        else
          flash[:notice] = "The confirmation code is not valid. Check your mail and confirm your confirmation code."
          redirect_to recovery_password_confirm_code_path
        end
      end
    end
  end

  def confirm_new_password
    if ( ! session.has_key?('recovery_password_confirmation_code')) && (( ! recovery_password_params.has_key? :confirmation_code) || recovery_password_params[:confirmation_code] == '')
      redirect_to recovery_password_confirm_code_path, notice: 'Confirmation code is void.'
    else
      @user = load_user_by_params_or_session
      if @user.nil?
        redirect_to recovery_password_confirm_code_path, notice: 'Confirmation code not found. '
      else
        session[:recovery_password_confirmation_code] = @user.recovery_password_confirmation_code
      end
    end
  end

  def set_new_password
    if ( ! session.has_key? ('recovery_password_confirmation_code')) && (( ! recovery_password_params.has_key? ('confirmation_code')) || recovery_password_params[:confirmation_code] == '')
      redirect_to recovery_password_confirm_code_path, notice: 'Confirmation code is void.'
    elsif ( ! recovery_password_params.has_key?('new_password')) || recovery_password_params[:new_password] == ''
      redirect_to recovery_password_confirm_new_password_path, notice: 'New password is void.'
    elsif ( ! recovery_password_params.has_key?('new_password_repeat')) || recovery_password_params[:new_password_repeat] == ''
      redirect_to recovery_password_confirm_new_password_path, notice: 'New password repeat is void.'
    elsif recovery_password_params[:new_password] != recovery_password_params[:new_password_repeat]
      redirect_to recovery_password_confirm_new_password_path, notice: 'New password not match.'
    else
      @user = load_user_by_params_or_session
      if @user.nil?
        redirect_to recovery_password_confirm_code_path, notice: 'Confirmation code not found.'
      else
        @user.password = recovery_password_params[:new_password]
        if @user.save
          session.delete :recovery_password_confirmation_code
          redirect_to login_path, notice: 'Password update successfully. Please login.'
        else
          redirect_to recovery_password_confirm_new_password_path, notice: @user.errors.inject('The password can not be update. ') { |errorText, element|
            errorText + 'The field ' + element[0].to_s + ' ' + element[1] + '. '
          }
        end
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def recovery_password_params
      params.fetch(:recovery_password, {}).permit(:username_or_email, :confirmation_code, :new_password, :new_password_repeat)
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

    def is_email?(username_or_email)
      username_or_email =~ User::EMAIL_VALID_FORMAT_PATTERN
    end

  def load_user_by_params_or_session
    if session.has_key?('recovery_password_confirmation_code')
      @user = User.find_by recovery_password_confirmation_code: session[:recovery_password_confirmation_code]
    else
      @user = User.find_by recovery_password_confirmation_code: recovery_password_params[:confirmation_code]
    end
  end

end
