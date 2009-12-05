module ApplicationHelper

	def format_time(time)
		time.strftime("%I:%M %p")
	end

	def format_datetime(datetime)
		datetime.strftime("%I:%M %p, %b #{datetime.day.ordinalize}")
	end

	def recruiter_candidate_options(recruiter)
		recruiter.candidates.collect{|candidate|[candidate.name, candidate.id]}
	end

end
