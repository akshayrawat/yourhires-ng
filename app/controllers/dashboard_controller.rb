class DashboardController < ApplicationController
  
  def index
    @upcoming_events = current_recruiter.upcoming_events[0..4]
  end
  
end