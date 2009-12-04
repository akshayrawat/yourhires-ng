class Feedback < ActiveRecord::Base
  belongs_to :interviewer
	
	def <=> other
		other.updated_at <=> self.updated_at
	end
	
end