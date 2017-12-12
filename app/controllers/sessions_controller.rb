class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to '/', notice: 'Thank you for registering!'
    else
      redirect_to '/login', notice: 'User Info not valid, try again'
    end
  end

  def destroy
    session.delete(:user_id)
    # session[:user_id] = nil
    redirect_to '/'
  end

end