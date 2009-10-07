class Candidate < ActiveRecord::Base
  
  has_many :recruitment_steps
  
  def register_for(*step_types)
    step_types.each do |step_type|
      self.recruitment_steps.create(:candidate_id => self.id, :recruitment_step_type => step_type)
    end
  end
  
  def all_interviewers
    recruitment_steps.collect do |recruitment_step|
      event = recruitment_step.event
      event.interviewers 
    end.flatten
  end
end