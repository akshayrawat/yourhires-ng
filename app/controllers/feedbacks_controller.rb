class FeedbacksController < ApplicationController  
	
	def index
		@feedbacks = current_candidate.feedbacks
	end

	def new
		@feedback = Feedback.new
	end

	def create
		Feedback.create(params[:feedback])
		redirect_to candidate_feedbacks_url(current_candidate)
	end

	def edit
		current_feedback
		render :action => :new
	end

	def update
		current_feedback.update_attributes(params[:feedback])
		redirect_to candidate_feedbacks_url(current_candidate)
	end

	private
	
	def current_feedback
		@feedback = Feedback.find(params[:id])		
	end

end