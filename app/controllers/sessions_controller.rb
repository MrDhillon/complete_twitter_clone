class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      #log user in and redirect to user show page
      log_in(@user)
      remember @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or user_path(@user)
    else
      #create error message
      flash.now[:danger] = "Invalid email/password"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
