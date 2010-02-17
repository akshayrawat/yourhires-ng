class EventsController < ApplicationController

	def index
		@events = current_recruiter.upcoming_events
	end
	
	def events_completed
		@events = current_recruiter.completed_events
		render :index
	end
	
	def events_unscheduled
		@unscheduled_recruitment_steps = current_recruiter.unscheduled_recruitment_steps
	end

	def show
		@event= Event.find(params[:id])
		render :partial => 'event', :locals => {:event => @event} and return if request.xhr?
	end
	
	def show_detail
		@event= Event.find(params[:id])
	end

	def new
		@event = Event.new(:recruitment_step => RecruitmentStep.find(params[:recruitment_step_id]))
	end
	
	def edit
		@event = Event.find(params[:id])
		render :new
	end
	
	def create
		@event = Event.new(params[:event])
		if @event.save
			Notifier.deliver_event_invitation(@event)
			redirect_to candidate_schedule_url(@event.recruitment_step.candidate)
		else
			render :new
		end
	end

	def update
		@event = Event.find(params[:id])
		if @event.update_attributes(params[:event])
			Notifier.deliver_event_invitation_update(@event)			
			redirect_to candidate_schedule_url(@event.recruitment_step.candidate)
		else
			render :edit
		end
	end
	
	def schedule_step
		render :text => "todo"
	end
	
	def interviewer_selection
		interviewer = Interviewer.new(:participant_id => params[:participant_id])
		render :partial => 'interviewer_selection', :locals => {:interviewer => interviewer}
	end

end