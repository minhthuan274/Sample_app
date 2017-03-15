class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy 

  def index
    @users = User.paginate page: params[:page], per_page: 10
    @users = User.where(activated: true).paginate(page: params[:page],
                                                  per_page: 10)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page],
                                            per_page: 4)
    redirect_to root_url unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      message  = "Please check your email to activate you account."
      message += "<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>"
      flash[:info] = message
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update 
      flash[:success] = "Profile updated"
      redirect_to @user
    else 
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy 
    flash[:success] = "User deleted!"
    redirect_to users_url
  end

  private 
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms the correct user 
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    # Confirm the admin user.
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
