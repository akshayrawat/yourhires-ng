require 'spec_helper'

describe Notifier do
  include ApplicationHelper
	
	context "event_invitation" do
		it "generates mail" do
			event = create_event
		  mail = Notifier.create_event_invitation event
			mail.to.should eql([event.interviewers.first.participant.email])
			mail.subject.should eql("Recruitment Invitation: #{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}")
			mail.from.should eql(["yourhires@gmail.com"])
		end
	end
	
	context "event_invitation_update" do
		it "generate mail" do
			event = create_event
		  mail = Notifier.create_event_invitation_update event
			mail.to.should eql([event.interviewers.first.participant.email])
			mail.subject.should eql("Recruitment Invitation Update: #{event.recruitment_step.recruitment_step_type.name} - #{event.recruitment_step.candidate.name}")
			mail.from.should eql(["yourhires@gmail.com"])
		end
	end
	
	def create_event
		EventFactory.create(:recruitment_step => 
										RecruitmentStepFactory.pairing(:candidate => CandidateFactory.create), 
																:interviewers => [Interviewer.create(:participant  => ParticipantFactory.create)])
	end
	
end
