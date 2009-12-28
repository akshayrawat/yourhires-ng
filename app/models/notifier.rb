class Notifier < ActionMailer::Base
	helper ApplicationHelper
	include EventIcalGeneration

	def event_invitation(event)
		recipients event.interviewers.collect{|i|i.participant.email}
		from       "yourhires@gmail.com"
		subject    "Recruitment Invitation: #{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}"
		content_type    "text/plain"
		body				render_message("event_invitation.text.plain", :event => event)

		attachment :content_type => 'text/icalendar', :filename => 'invite.ics', :body => generate_ical([event])
	end

end
