class TweetsController < ApplicationController
  before_action :require_user

  def show
    @tweet = Tweet.find(params[:id])
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
end