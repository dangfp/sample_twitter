class HashtagsController < ApplicationController
  def show
    @hashtag_tweets = Tweet.where("body like ?", "%##{params[:id]}%")
  end
end