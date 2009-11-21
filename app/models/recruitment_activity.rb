class RecruitmentActivity < ActiveRecord::Base

  belongs_to :candidate
  belongs_to :recruiter

  def self.new_candidate(candidate)
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "New candidate <a href='/candidates/'>#{candidate.name}</a> was created")
  end

  def self.candidate_updated(candidate)
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "Candidate <a href='/candidates/'>#{candidate.name}</a> was updated")
  end

  def self.new_event(event)
    candidate= event.recruitment_step.candidate    
    RecruitmentActivity.create(:candidate => candidate, :recruiter => RecruiterSession.find.recruiter,
                  :message => "New event <a href='/candidates/#{candidate.id}/recruitment_steps/#{event.recruitment_step.id}/events/new'>#{event.recruitment_step.recruitment_step_type.name}</a> was scheduled.")
  end

  def self.event_updated(event)
    candidate= event.recruitment_step.candidate    	
    RecruitmentActivity.create(:candidate => event.recruitment_step.candidate, :recruiter => RecruiterSession.find.recruiter,
                          :message => "<a href='/candidates/#{candidate.id}/recruitment_steps/#{event.recruitment_step.id}/events/new'>#{event.recruitment_step.recruitment_step_type.name}</a> was scheduled.")
  end

  def self.recent
    self.find(:all, :order => "updated_at DESC", :limit => 10)
  end

end