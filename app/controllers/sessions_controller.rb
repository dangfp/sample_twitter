class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "You've logged in."
      redirect_to root_path
    else
      flash[:error] = "The something is wrong with username or password."
      render :new
    end
  end

  def destory
    session[:user_id] = nil
    flash[:notice] = "You've logged out."
    redirect_to root_path
  end
end