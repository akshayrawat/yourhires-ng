class CalendarsController < ApplicationController
	skip_before_filter :ensure_login
	
	def show
		respond_to do |format|
			format.ics{render :text => generate_icalendar.to_ical}
			format.any{render :text => "", :status => 400}
		end
	end

	def generate_icalendar
		Event.all.inject(Icalendar::Calendar.new) do |calendar, event|
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
		end		
	end

	def summary(event)
		"#{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}"	
	end

end
