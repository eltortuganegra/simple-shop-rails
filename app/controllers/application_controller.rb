class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def render_404
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
    end

    def login(user_id)
      session[:user_id] = user_id
    end

    def logout
      reset_session
    end

    def is_user_loggin?
      session.has_key?(:user_id) && ! session[:user_id].nil?
    end

    def is_user_administrator?
      session.has_key?(:is_administrator) && session.has_key?(:is_administrator)
    end
end
