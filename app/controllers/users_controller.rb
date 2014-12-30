class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
    @composed_tweets = @user.tweets
  end

  def new
    @user = User.new

  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "You age registed."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "You have updated profile."
      redirect_to root_path
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(session[:user_id])
    end
end