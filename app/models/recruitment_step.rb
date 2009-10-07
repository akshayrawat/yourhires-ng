class RecruitmentStep < ActiveRecord::Base
  belongs_to :candidate
  has_one :event
  belongs_to :recruitment_step_type  
end