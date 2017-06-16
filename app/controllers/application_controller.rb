class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authorize
    redirect_to login_path, alert: "Please create an account or login" unless current_user
  end

  def current_user?(user)
    user == current_user
  end
end
