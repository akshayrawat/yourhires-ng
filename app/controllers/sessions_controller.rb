class SessionsController < ApplicationController
  include AuthenticatedSystem
  layout false
  
  def new
    @user = User.new
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:user][:login], params[:user][:password])
    if user
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    else
      flash[:error] = "Couldn't log you in as '#{params[:user][:login]}'"
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/')
  end
  
end
