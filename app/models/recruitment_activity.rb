class RecruitmentActivity < ActiveRecord::Base

  belongs_to :candidate
  belongs_to :recruiter

  def self.new_candidate(candidate)
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "New candidate #{candidate_url(candidate)} was created.")
  end

  def self.candidate_updated(candidate)
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "Candidate #{candidate_url(candidate)} was updated.")
  end

  def self.new_event(event)
    candidate= event.recruitment_step.candidate    
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "New event #{event_url(event, candidate)} for #{candidate_url(candidate)} was scheduled.")
  end

  def self.event_updated(event)
    candidate= event.recruitment_step.candidate    	
    RecruitmentActivity.create(:candidate => event.recruitment_step.candidate, :recruiter => RecruiterSession.find.recruiter,
                          :message => "#{event_url(event, candidate)} for #{candidate_url(candidate)} was updated.")
  end

  def self.recent
    self.find(:all, :order => "updated_at DESC", :limit => 15)
  end
	
	private
	
	def self.candidate_url(candidate)
		"<a href='/candidates/'>#{candidate.name}</a>"
	end
	
	def self.event_url(event, candidate)
		"<a href='/candidates/#{candidate.id}/recruitment_steps/#{event.recruitment_step.id}/events/new'>#{event.recruitment_step.recruitment_step_type.name}</a>"
	end

end