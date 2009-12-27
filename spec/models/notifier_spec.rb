require 'spec_helper'

describe Notifier do
  include ApplicationHelper
	
	context "event_invitation" do
		it "generates mail" do
			event = EventFactory.create(:recruitment_step => 
											RecruitmentStepFactory.pairing(:candidate => CandidateFactory.create), 
																	:interviewers => [Interviewer.create(:participant  => Participant.create(:email => "one@yh.com"))])
		  mail = Notifier.create_event_invitation event
		
			mail.to.should eql([event.interviewers.first.participant.email])
			mail.subject.should eql("Recruitment Invitation: #{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}")
			mail.from.should eql(["yourhires@gmail.com"])
			mail.body.should match(/#{event.recruitment_step.recruitment_step_type.name}/)
			mail.body.should match(/#{event.recruitment_step.candidate.name}/)
			mail.body.should match(/#{format_datetime(event.start_time)}/)
			mail.body.should match(/#{format_datetime(event.end_time)}/)
			mail.body.should match(/#{event.venue}/)
			mail.body.should match(/#{event.comment}/)
		end
	end
	
end
