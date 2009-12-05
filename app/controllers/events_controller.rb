class EventsController < ApplicationController

	def index
		@events = current_recruiter.upcoming_events
	end

	def show
		@event= Event.find(params[:id])
		render :partial => 'event', :locals => {:event => @event} and return if request.xhr?
	end

	def new
		@selected_candidate= 
		current_candidate.nil? ? Candidate.new : current_candidate

		if params[:recruitment_step_id].blank?
			@recruitment_steps = @selected_candidate.recruitment_steps
		else
			@selected_recruitment_step= RecruitmentStep.find(params[:recruitment_step_id])
			@recruitment_steps = [@selected_recruitment_step]
		end
	end

	def create
		handle_action(Event.new(params[:event]), "Event was Created") do |event|
			event.save
		end
	end

	def update
		handle_action(Event.find(params[:id]), "Event was Updated") do |event|
			event.update_attributes(params[:event])
		end
	end

	private

	def handle_action(event, success_message)
		render :update do |page|
			if yield(event)
				@message= success_message
			else          
				event.recruitment_step.event = event #HACK
				@message = "Please enter the highlighted fields"
			end
			page.replace dom_id(event.recruitment_step), 
			:partial => "recruitment_step", 
			:locals => {:recruitment_step => event.recruitment_step, :message => @message}
		end
	end

end