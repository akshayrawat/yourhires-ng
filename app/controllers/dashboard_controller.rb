class DashboardController < ApplicationController
  
  def index
    @upcoming_events = current_recruiter.upcoming_events[0..4]
    @recruitment_activities = RecruitmentActivity.recent
		load_sidebar_data
  end
	
	def load_sidebar_data
		@roles_in_pipeline= RecruitmentStatistics.roles_in_pipeline
		@recruiting_sources = RecruitmentStatistics.recruiting_sources
		@steps_pending_in_pipeline = RecruitmentStatistics.steps_pending_in_pipeline
	end
	  
end