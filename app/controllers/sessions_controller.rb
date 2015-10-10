class SessionsController < ApplicationController
  def create
    respond_to do |format|
      user = nil
      if idenfitier_is_a_valid_username?
        user = User.find_by(username: user_params[:username_or_email])
      elsif idenfitier_is_email?
        user = User.find_by(email: user_params[:username_or_email])
      end

      if can_user_login? user
        session.delete(:username_or_email)
        format.html { redirect_to user_path(user), notice: 'You are logged successfully.' }
        format.json { render :show, status: :created, location: user }
      else
        session[:username_or_email] = user_params[:username_or_email]
        if user.confirmation_code.nil?
          format.html { redirect_to login_path, notice: 'The username and password that you entered did not match our records. Please double-check and try again.' }
        else
          format.html { redirect_to login_path, notice: 'You must confirm your account. Please check your email and look for the confirmation code.' }
        end
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:session).permit(:username_or_email, :password)
    end

    def idenfitier_is_a_valid_username?
      user_params[:username_or_email] =~ User::USERNAME_VALID_FORMAT_PATTERN
    end

    def idenfitier_is_email?
        user_params[:username_or_email] =~ User::EMAIL_VALID_FORMAT_PATTERN
    end

    def can_user_login? (user)
      ! user.nil? && user.confirmation_code.nil? && user.authenticate(user_params[:password])
    end
end
