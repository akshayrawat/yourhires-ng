class DashboardController < ApplicationController
  
  def index
    @upcoming_events = current_recruiter.upcoming_events[0..4]
    @recruitment_activities = RecruitmentActivity.recent
		
		@positions_in_pipeline= build_statistics_by_sql("select role_id, count(*) from candidates group by role_id")
		@recruiting_sources = build_statistics_by_sql("select source, count(*) from candidates group by source")
		@steps_pending_in_pipeline = build_statistics_by_sql("select recruitment_step_type_id, count(*) from recruitment_steps group by recruitment_step_type_id")
  end

	def build_statistics_by_sql sql
		stats_counts = ActiveRecord::Base.connection.select_rows(sql)
		
		stats_counts.inject({}) do |statistics, stat_count|
			statistics[stat_count.first] = stat_count.last
			statistics
		end
	end
  
end