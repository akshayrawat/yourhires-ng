module CandidatesHelper
	
	def feedback_result_class(event)
		return "undecided" if event.feedbacks.all?{|feedback| feedback.feedback_result == Feedback::FeedbackResult::UNDECIDED}

		return "pursue" if event.feedbacks.reject{|feedback| feedback.feedback_result == Feedback::FeedbackResult::UNDECIDED}.all?{|feedback|feedback.feedback_result == Feedback::FeedbackResult::PURSUE}
		
		return "pass" if event.feedbacks.any?{|feedback| feedback.feedback_result == Feedback::FeedbackResult::PASS} 
	end
	
end