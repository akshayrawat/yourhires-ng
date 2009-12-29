module EventIcalGeneration
	
	def generate_ical(events)
		events.inject(Icalendar::Calendar.new) do |calendar, event|
			calendar_event = Icalendar::Event.new
			calendar_event.start = event.start_time.to_datetime
			calendar_event.end = event.end_time.to_datetime
			calendar_event.location = event.venue
			calendar_event.organizer = event.recruitment_step.candidate.recruiters.collect(&:name).join(",")
			calendar_event.summary = summary(event)
			calendar_event.attendees=event.interviewers.collect(&:name)
			calendar_event.description = event.comment
			calendar.add calendar_event
			calendar
		end.to_ical
	end
	
	private
	def summary(event)
		"#{event.recruitment_step.name} - #{event.recruitment_step.candidate.name}"	
	end
end