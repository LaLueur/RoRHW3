class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def update_views
    cookies[:views] = if cookies[:views].present?
                        cookies[:views].to_i + 1
                      else
                        1
                      end
  end

  helper_method :current_user
end
