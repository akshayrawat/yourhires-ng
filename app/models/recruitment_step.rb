class RecruitmentStep < ActiveRecord::Base
  belongs_to :candidate
  has_one :event
  belongs_to :recruitment_step_type  
  
  def completed?
    !pending?
  end
  
  def pending?
    !scheduled? || upcoming?
  end
  
  def upcoming?
    scheduled? && self.event.in_future?
  end
  
  def scheduled?
    !self.event.nil?
  end
  
end