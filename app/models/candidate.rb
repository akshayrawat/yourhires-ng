class Candidate < ActiveRecord::Base
  
  has_many :recruitment_steps, :include => ["event"], :order => "events.start_time ASC"
  has_and_belongs_to_many :recruiters
  belongs_to :role
  
  validates_presence_of :name, :phone, :email, :source, :role_id
  
  def register_for_steps(*step_types)
    step_types.each do |step_type|
      self.recruitment_steps.create(:recruitment_step_type => step_type)
    end
  end
    
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
  
  private  
end