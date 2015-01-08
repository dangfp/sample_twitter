class TweetsController < ApplicationController
  before_action :require_user
  before_action :set_tweet, only: [:show, :retweet]

  def show
    
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(params.require(:tweet).permit(:body, :creator))
    @tweet.creator = current_user

    if @tweet.save
      flash[:notice] = "Your tweet was composed."
      redirect_to root_path
    else
      render :new
    end
  end

  def retweet
    retweet = Retweet.new(retweetor: current_user, tweet: @tweet)

    if retweet.save
      flash[:notice] = "You've retweet successfully."
    else
      flash[:error] = "You've retweet unsuccessfully."
    end
    redirect_to :back
  end

  private

    def set_tweet
      @tweet = Tweet.find(params[:id])
    end
end