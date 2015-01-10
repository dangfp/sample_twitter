class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  before_action :set_user, only: [:show, :follow, :unfollow]
  before_action :require_current_user , only: [:edit, :update, :mentions]

  def index
    @composed_tweets = current_user.all_tweets_for_display
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
    current_user.followings << @user
    flash[:notice] = "You've followed #{@user.username}."
    redirect_to :back
  end

  def unfollow
    Relationship.find_by(followed_id: params[:id], follower_id: current_user.id).destroy
    flash[:notice] = "You've unfollowed #{@user.username}."
    redirect_to :back
  end

  def following
    @following = current_user.followings
  end

  def followers
    @followers = current_user.followers
  end

  def mentions
    @user.mark_mentions_to_read
  end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_current_user
      if current_user.id.to_s == params[:id]
        @user = current_user
      else
        flash[:error] = "Only for current user to do that."
        redirect_to root_path
      end
    end
end