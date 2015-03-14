class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  protect_from_forgery
  
  # Uses Authlogic to manage user sessions.
  # 
  # Methods to check for session and to set the current_user if current_user_session are available. 
  # 
  # 'require_no_user' used in login_controller to make sure only usrs with no session can access /login.
  # 
  # 'deny_access' used in all controllers which requires users to be logged in for an action to be performed.
  # 
  # 'store_location' and 'redirect_back_or_default' are used to support redirection in logins.

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
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
