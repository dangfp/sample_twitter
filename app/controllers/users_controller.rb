class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :follow]

  def index
    @composed_tweets = []
    User.where(id: current_user.not_to_be_followed_user_ids).each do |user|
      @composed_tweets += user.tweets
    end
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

  def who_to_follow
    @who_to_follow = current_user.who_to_follow
  end

  def follow
    to_follow_user = User.find(params[:id])

    current_user.followings << to_follow_user
    flash[:notice] = "You've followed #{to_follow_user.username}."
    redirect_to :back
  end

  def unfollow
    followed_user = User.find(params[:id])
    Relationship.find_by(followed_id: params[:id], follower_id: current_user.id).delete
    flash[:notice] = "You've unfollowed #{followed_user.username}."
    redirect_to :back
  end

  def following
    @following = current_user.followings
  end

  def followers
    @followers = current_user.followers
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(session[:user_id])
    end
end