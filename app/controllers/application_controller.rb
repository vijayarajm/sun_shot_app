class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  protect_from_forgery
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find
  end  

  def current_user
    @current_user = current_user_session && current_user_session.record  
  end

  def require_no_user
    if authorized?
      store_location
      redirect_to home_path
      return false
    end
  end

  def deny_access
    unless authorized?
      store_location
      flash[:error] = "You are not allowed to access this page."
      redirect_to login_path 
    end
  end

  def authorized?
    current_user
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
