class CandidatesController < ApplicationController  

	def index
		@candidates = current_recruiter.candidates
	end

	def new
		@candidate = Candidate.new
	end
	
	def edit
		render :action => :new
	end

	def create
		@candidate = Candidate.new(params[:candidate])
		if @candidate.save
			redirect_to candidate_url(@candidate)
		else
			render :new
		end
	end
	
	def update
		if @candidate.update_attributes(params[:candidate])
			redirect_to candidate_url(@candidate)
		else
			render :new
		end
	end

	def show
	end

	def schedule
		@events = current_candidate.recruitment_steps_scheduled.map(&:event)
	end

	def feedbacks
	end
	
	def recruiter_selection
		render :partial => "recruiter_selection", :locals => {:recruiter =>	Recruiter.find(params[:recruiter_id]), :new_record => params[:new_record]}
	end
	
	def recruitment_step_type_selection
		recruitment_step_type = RecruitmentStepType.find(params[:recruitment_step_type_id])
		render :partial => "recruitment_step_type_selection", :locals => {:recruitment_step => RecruitmentStep.new(:recruitment_step_type => recruitment_step_type)}
	end
	
end