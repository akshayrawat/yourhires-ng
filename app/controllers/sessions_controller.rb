class SessionsController < ApplicationController
  include AuthenticatedSystem
  
  def new
    @user = User.new
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/')
  end

protected
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
  end
end
