class EventsController < ApplicationController

  def index
    upcoming_recruitment_steps = current_recruiter.candidates.collect do |candidate|
      candidate.recruitment_steps_upcoming
    end

    @events = upcoming_recruitment_steps.flatten.collect{|recruitment_step| recruitment_step.event}
  end

  def new
    @candidate = Candidate.find(params[:candidate_id]) unless params[:candidate_id].blank?
  end

  def recruitment_steps
    render :nothing => true and return if params[:candidate_id].blank?
    render :partial => "recruitment_step", 
           :collection => Candidate.find(params[:candidate_id]).recruitment_steps
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