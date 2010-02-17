class RecruitmentStatistics
		
	def self.roles_in_pipeline
		build_stat_counts_by_sql "select role_id, count(*) from candidates group by role_id"
	end
	
	def self.recruiting_sources
		build_stat_counts_by_sql "select source, count(*) from candidates group by source"
	end
	
	def self.steps_pending_in_pipeline
		build_stat_counts_by_sql "select recruitment_step_type_id, count(*) from recruitment_steps group by recruitment_step_type_id"
	end
	
	def self.build_stat_counts_by_sql sql
		stats_counts = ActiveRecord::Base.connection.select_rows(sql)
		stats_counts.inject({}) do |statistics, stat_count|
			statistics[stat_count.first] = stat_count.last
			statistics
		end
	end
	
end