class DashboardController < ApplicationController
  
  def index
    @upcoming_events = current_recruiter.upcoming_events[0..4]
    @recruitment_activities = RecruitmentActivity.recent
  end
  
end