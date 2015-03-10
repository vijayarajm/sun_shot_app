class UsersController < ApplicationController

  # GET /users - render users page. Lists all users - with pagination and filters.
  # 
  # POST /users - adds a new user.
  # 
  # PUT /users/{id} - update existing user data.
  # 
  # DELETE /locations/{location_id}/data - deletes users with given user ids 
  # (except the default admin - using 'default_user?'' in the before_filter)

  DEFAULT_USER = "admin"

  before_filter :deny_access
  before_filter :default_user?, :only => [:destroy, :destroy_multiple]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "User created!"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to users_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated!"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to users_path
    end
  end

  def index
    if params[:filter_param]
      users = User.where("#{params[:filter_param]} = '#{params[:filter_value]}'")
      @users = users.paginate(:page => params[:page], :per_page => 30)
    else
      @users = User.paginate(:page => params[:page], :per_page => 30)
    end
  end

  def destroy
    users = User.where(:id => params[:user_ids])
    users.destroy_all

    flash[:notice] = "User deleted!"
    redirect_to users_path
  end

  def destroy_multiple
    users = User.where(:id => params[:user_ids])
    users.destroy_all

    flash[:notice] = "Users deleted!"
    redirect_to users_path
  end

  private
    def default_user?
      user = User.find_by_username(DEFAULT_USER)
      
      if user and params[:user_ids].include?(user.id.to_s)
        flash[:error] = "Default (admin) user cannot be deleted!"
        redirect_to users_path
      end
    end

end