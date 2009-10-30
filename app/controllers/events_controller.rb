class EventsController < ApplicationController

  def index
    upcoming_recruitment_steps = current_recruiter.candidates.collect do |candidate|
      candidate.recruitment_steps_upcoming
    end

    @events = upcoming_recruitment_steps.flatten.collect{|recruitment_step| recruitment_step.event}
  end

  def new
    @event = Event.new
  end
end