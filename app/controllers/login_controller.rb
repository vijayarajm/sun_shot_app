class LoginController < ApplicationController
  before_filter :require_no_user, :only => [ :new, :create ]
  
  # Methods to create/destroy user_sessions.
  # 
  # /login supports redirect param in the URL (/login?redirect=<redirect_url>)

  def new
    @user_session = UserSession.new
  end

  def create  
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if params[:redirect]
        redirect_to params[:redirect]
      else
        redirect_back_or_default home_path
      end
    else
      flash[:error] = "Incorrect email or password!"
      redirect_to login_path
    end 
  end

  def destroy  
    @user_session = UserSession.find
    @user_session.destroy  
    redirect_to login_path  
  end
end