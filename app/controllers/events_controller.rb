class EventsController < ApplicationController
  
  def index
    upcoming_recruitment_steps = current_recruiter.candidates.collect{|candidate| candidate.recruitment_steps_upcoming}
    @events = upcoming_recruitment_steps.flatten.uniq.collect{|recruitment_step| recruitment_step.event}
  end
end