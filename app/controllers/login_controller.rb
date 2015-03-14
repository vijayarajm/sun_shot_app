class LoginController < ApplicationController
  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :check_for_blank, :only => :create
  
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
      flash[:error] = "Incorrect username or password! Please check..."
      redirect_to login_path
    end 
  end

  def destroy  
    @user_session = UserSession.find
    @user_session.destroy  
    redirect_to login_path  
  end

  private
    def check_for_blank
      if params[:user_session][:username].blank? or params[:user_session][:password].blank?
        flash[:error] = "Username or Password fields can't be blank!"
        redirect_to login_path
      end
    end
end