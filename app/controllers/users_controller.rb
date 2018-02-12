class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.micropost.paginate(page: params[:page])
    #redirect_to root_url and return unless FILL_IN
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    	@user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
    	#flash.now[:danger] = 'Tidak ada yang boleh kosong'
    	render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
   @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User #{@user.name} Deleted"
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end
end