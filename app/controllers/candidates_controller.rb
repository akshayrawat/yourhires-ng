class CandidatesController < ApplicationController  

	def index
		@candidates = current_recruiter.candidates
	end
	
	def new
		@candidate = Candidate.new
	end

	def create
		@candidate = Candidate.new(params[:candidate])

		if @candidate.save
			redirect_to candidates_url
		else
			render :new
		end
	end
	
	def show
		@candidate = current_candidate
	end
	
	def schedule
		@events = current_candidate.recruitment_steps_scheduled.map(&:event)
	end
	
	def feedbacks
	  @candidate = current_candidate
	end
	
	private

	def current_candidate
		@candidate = Candidate.find(params[:id])
	end

end