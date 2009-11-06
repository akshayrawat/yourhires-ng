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
    recruitment_steps = Candidate.find(params[:candidate_id]).recruitment_steps
    render :partial => "recruitment_step", :collection => recruitment_steps
  end

  def create
    handle_action(Event.new(params[:event]), "Event was Created") do |event|
      event.save(params[:event])
    end
  end

  def update
    handle_action(Event.find(params[:id]), "Event was Updated") do |event|
      event.update_attributes(params[:event])
    end
  end

  def handle_action(event, message)
    if yield(event)
      render :update do |page|
        @message= message
        page.replace dom_id(event.recruitment_step), :partial => "recruitment_step", :locals => {:recruitment_step => event.recruitment_step, :message => @message}
        page.visual_effect(:grow, "#{dom_id(event.recruitment_step.id)}_message")
      end
    else
      render :new
    end
  end

end