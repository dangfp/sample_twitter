class RepliesController < ApplicationController
  def new
    @reply = Tweet.new
    @tweet = Tweet.find(params[:id])
  end

  def create
    @reply = Tweet.new(body: params[:tweet][:body], creator: current_user, parent_id: params[:id])

    if @reply.save
      flash[:notice] = "You've reply successfully."
      redirect_to root_path
    else
      flash[:error] = @reply.errors.full_messages
      redirect_to :back
    end
  end
end