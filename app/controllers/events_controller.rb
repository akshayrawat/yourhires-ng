class EventsController < ApplicationController

  def index
    upcoming_recruitment_steps = current_recruiter.candidates.collect do |candidate|
      candidate.recruitment_steps_upcoming
    end

    @events = upcoming_recruitment_steps.flatten.collect{|recruitment_step| recruitment_step.event}
  end

  def new
  end
  
  def event_details
    @new_event = Event.new
    
    @recruitment_steps = []
    @recruitment_steps = Candidate.find(params[:candidate_id]).recruitment_steps unless params[:candidate_id].blank?
    render :partial => "recruitment_steps"
  end
  
  def create
    @event = Event.new(params[:event])
    
    if @event.save!
      redirect_to events_url
    else
      render :new
    end
  end
end