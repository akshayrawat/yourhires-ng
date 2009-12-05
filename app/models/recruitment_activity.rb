class RecruitmentActivity < ActiveRecord::Base	
  belongs_to :candidate
	xss_terminate :except => [:message]

  def self.candidate_event(params)
		candidate = params[:record]
		operation = params[:operation]
		recruiter = RecruiterSession.find.recruiter
				
    RecruitmentActivity.create(:candidate => candidate, :posted_by => recruiter.name,
                  :message => "Candidate #{candidate_url(candidate)} was #{operation}.")
  end

  def self.feedback_event(params)
		feedback = params[:record]
		operation = params[:operation]
		recruiter = RecruiterSession.find.recruiter
    candidate= feedback.interviewer.event.recruitment_step.candidate

    RecruitmentActivity.create(:candidate => candidate, :posted_by => recruiter.name,
                  :message => "#{feedbacks_url(candidate)} for #{candidate_url(candidate)} was #{operation}.")
  end

  def self.event_event(params)
		event = params[:record]
		operation = params[:operation]
    candidate= event.recruitment_step.candidate
		recruiter = RecruiterSession.find.recruiter
		
    RecruitmentActivity.create(:candidate => candidate, :posted_by => recruiter.name,
                  :message => "Event #{event_url(event, candidate)} for #{candidate_url(candidate)} was #{operation}.")
  end

  def self.recent(candidate=nil)
		conditions = candidate.nil? ? [] : ["candidate_id = ?", candidate.id]
    self.find(:all, :conditions => conditions, :order => "updated_at DESC", :limit => 15)
  end
	
	private
	
	def self.candidate_url(candidate)
		"<a href='/candidates/#{candidate.id}'>#{candidate.name}</a>"
	end
	
	def self.event_url(event, candidate)
		"<a href='/events/#{event.id}'>#{event.recruitment_step.recruitment_step_type.name}</a>"
	end
	
	def self.feedbacks_url(candidate)
		"<a href='/candidates/#{candidate.id}/feedbacks'>Feedback</a>"		
	end

end