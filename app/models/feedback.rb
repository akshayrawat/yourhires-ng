class Feedback < ActiveRecord::Base
  belongs_to :interviewer
	validates_presence_of :feedback_result

	enum :FeedbackResult do
		PASS("Pass")
		PURSUE("Pursue")
		UNDECIDED("Undecided")

		attr_reader :description

		def init description
			@description = description
		end
	end
	
 	constantize_attribute :feedback_result
	
	def <=> other
		other.updated_at <=> self.updated_at
	end
	
end