class EventsController < ApplicationController

  def index
    upcoming_recruitment_steps = current_recruiter.candidates.collect do |candidate|
      candidate.recruitment_steps_upcoming
    end

    @events = upcoming_recruitment_steps.flatten.collect{|recruitment_step| recruitment_step.event}
  end

  def new
    @selected_candidate= 
        params[:candidate_id].blank? ? Candidate.new : Candidate.find(params[:candidate_id])
    
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