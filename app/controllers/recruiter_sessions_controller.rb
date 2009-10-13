class RecruiterSessionsController < ApplicationController
  layout false
  
  def new
    @recruiter_session = RecruiterSession.new
  end

  def create
    @recruiter_session = RecruiterSession.new(params[:recruiter_session])
    if @recruiter_session.save
      redirect_to dashboard_url
    else
      flash[:error] = "Username or Password is invalid"
      render :action => :new
    end
  end

  def destroy
    current_recruiter_session.destroy
    redirect_to new_recruiter_session_url
  end
end
