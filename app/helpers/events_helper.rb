module EventsHelper
	
	def event_title_class(recruitment_step)
		return "completed-event-title" if recruitment_step.completed?
		return "upcoming-event-title" if recruitment_step.upcoming?
		return "unscheduled-event-title" if recruitment_step.unscheduled?
	end
end