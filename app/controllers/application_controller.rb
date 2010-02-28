require 'authlogic'

class ApplicationController < ActionController::Base

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_recruiter_session, :current_recruiter
  before_filter :ensure_login, :current_candidate

  protect_from_forgery
  
  private
  def current_recruiter_session
    return @current_recruiter_session if defined?(@current_recruiter_session)
    @current_recruiter_session = RecruiterSession.find
  end

  def current_recruiter
    return @current_recruiter if defined?(@current_recruiter)
    @current_recruiter = current_recruiter_session && current_recruiter_session.recruiter 
  end
  
  def ensure_login
    redirect_to new_recruiter_sessions_url and return if current_recruiter_session.nil? 
  end

	def current_candidate
		candidate_id = self.class == CandidatesController ? params[:id] : params[:candidate_id]
		@candidate ||= Candidate.find(candidate_id) unless candidate_id.blank?
	end

end
