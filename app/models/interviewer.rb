class Interviewer < ActiveRecord::Base
  belongs_to :participant
  belongs_to :event
  has_many :feedbacks

	def name
		participant.name
	end
	
end