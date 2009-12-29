class FeedbacksController < ApplicationController  
	
	def index
		if params[:event_id].blank?
			@feedbacks = current_candidate.feedbacks
		else
			@feedbacks = Event.find(params[:event_id]).feedbacks
		end
	end

	def new
		@feedback = Feedback.new
	end

	def create
		@feedback= Feedback.new(params[:feedback])
		if @feedback.save
			redirect_to candidate_feedbacks_url(current_candidate)
		else
			render :new
		end
	end

	def edit
		current_feedback
		render :new
	end

	def update
		if current_feedback.update_attributes(params[:feedback])
			redirect_to candidate_feedbacks_url(current_candidate)
		else
			render :new
		end
	end

	private
	
	def current_feedback
		@feedback = Feedback.find(params[:id])		
	end

end