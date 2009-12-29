class FeedbackFactory
	
	def self.create(params= {})
		Feedback.create(valid_params.merge(params))
	end
	
	def self.valid_params
		{:feedback_result => Feedback::FeedbackResult::PASS}
	end
end
