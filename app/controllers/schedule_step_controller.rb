class ScheduleStepController < ApplicationController

	def show
		@candidates = Candidate.all
		@recruitment_steps = current_candidate.nil? ? [] : current_candidate.recruitment_steps
	end

	def recruitment_steps
		@recruitment_steps = current_candidate.recruitment_steps
		render :partial => 'recruitment_steps'
	end

	def navigate_to_recruitment_step
		recruitment_step = RecruitmentStep.find(params[:recruitment_step_id])
		candidate = recruitment_step.candidate

		url = recruitment_step.scheduled? ?
		edit_candidate_recruitment_step_event_url(candidate, recruitment_step, recruitment_step.event) :
		new_candidate_recruitment_step_event_url(candidate, recruitment_step)
		render :update do |page|
			 page.redirect_to url 
		end
	end
end