class RecruitmentStep < ActiveRecord::Base
  belongs_to :candidate
  has_one :event
  belongs_to :recruitment_step_type  
  
  def completed?
    scheduled? && !upcoming?
  end
    
  def upcoming?
    scheduled? && self.event.in_future?
  end
  
  def scheduled?
    !unscheduled?
  end

	def unscheduled?
		self.event.nil?
	end
  
end