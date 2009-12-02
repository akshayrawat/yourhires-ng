class FeedbacksController < ApplicationController  

	def index
		@feedbacks = current_candidate.feedbacks
	end

	private

	def current_candidate
		@candidate = Candidate.find(params[:candidate_id])
	end

end