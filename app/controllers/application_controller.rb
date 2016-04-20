class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :session_simbolize_keys

  protected
    def render_404
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end

    def logout
      reset_session
    end

    def is_user_loggin?
      session.has_key?(:user) && ! session[:user].nil?
    end

    def is_user_administrator?
      is_user_loggin? && session[:user].has_key?(:is_administrator) && session[:user][:is_administrator]
    end

    def session_simbolize_keys
      session[:user].symbolize_keys! if is_user_loggin?
    end

    def user_must_be_logged
      redirect_to login_url if ! is_user_loggin?
    end
end
