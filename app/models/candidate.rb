class Candidate < ActiveRecord::Base
  
  has_many :recruitment_steps, :include => ["event"], :order => "events.start_time ASC"
  has_and_belongs_to_many :recruiters
  belongs_to :role
  has_attached_file :resume
  
  validates_presence_of :name, :phone, :email, :source, :role_id, :recruitment_steps, :recruiters
      
  def participants
    recruitment_steps.select(&:scheduled?).collect do |recruitment_step|
      recruitment_step.event.interviewers.collect{|interviewer|interviewer.participant}
    end.flatten.uniq
  end
  
  def schedule(recruitment_step, event)
    raise "Candidate not registered for this step" unless recruitment_steps.any?{|step|step.id == recruitment_step.id}
    recruitment_step.event= event
  end
    
  def recruitment_steps_completed
    recruitment_steps.select(&:completed?)
  end

  def recruitment_steps_pending
    recruitment_steps.select(&:pending?)
  end

  def recruitment_steps_upcoming
    recruitment_steps.select(&:upcoming?)
  end
  
  def recruitment_step_selections=(recruitment_step_types)
    register_for_steps(RecruitmentStepType.find(recruitment_step_types)) unless recruitment_step_types.empty?
  end

  def recruiter_selections=(*recruiters)
    self.recruiters = Recruiter.find(recruiters.uniq)
  end
    
  def register_for_steps(step_types)
    step_types.each do |step_type|
      self.recruitment_steps.build(:recruitment_step_type => step_type)
    end
  end
  
end