class Notifier < ActionMailer::Base
	helper ApplicationHelper	
	
	def event_invitation(event)
		recipients event.interviewers.collect{|i|i.participant.email}
		from       "yourhires@gmail.com"
		subject    "Recruitment Invitation: #{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}"
		body       :event => event
	end

end
