require File.dirname(__FILE__) + '/../spec_helper'

describe RecruitmentActivity do

	describe "for candidates" do
		it "should create a new instance for a candidate create/update event" do
			candidate = CandidateFactory.create
			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.candidate_event({:record => candidate})

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.posted_by.should eql(recruiter.name)
			activity.message.should_not be_blank
		end
	end

	describe "for events" do
		it "should create a new instance for a event create/update event" do
			event = EventFactory.create
			pairing = RecruitmentStepFactory.pairing(:event => event)
			candidate= CandidateFactory.create
			candidate.recruitment_steps = [pairing]

			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.event_event({:record => event})

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.posted_by.should eql(recruiter.name)
			activity.message.should_not be_blank			
		end	
	end

	describe "for feedbacks" do
		it "should create a new instance for a feedback create/update event" do
			pairing_event = EventFactory.create
			pairing = RecruitmentStepFactory.pairing(:event => pairing_event)
			candidate = CandidateFactory.create(:recruitment_steps => [pairing])
			recruiter = candidate.recruiters.first
			feedback = FeedbackFactory.create

			Interviewer.create!(:event => pairing_event, :participant => ParticipantFactory.create, :feedbacks=> [feedback])
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))

			RecruitmentActivity.feedback_event({:record => feedback})

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.posted_by.should eql(recruiter.name)
			activity.message.should_not be_blank			
		end	
	end

	describe "recent" do

		it "be the last the 15 recruitment activities" do
			activites= 15.times.collect { RecruitmentActivity.create!}
			10.times{RecruitmentActivity.create!(:updated_at => 10.minutes.ago)}

			RecruitmentActivity.recent.should eql(activites)
		end

		it "be the last activities of specified candidate" do
			one = CandidateFactory.create
			two = CandidateFactory.create
			ones_activites= 5.times.collect { RecruitmentActivity.create!(:candidate => one)}
			twos_activites= 5.times.collect { RecruitmentActivity.create!(:candidate => two)}

			RecruitmentActivity.recent(one).should eql(ones_activites)
		end
	end

	describe "html sanitization" do
		it "is skipped for message because it has links" do
			link = "<a href='#'>Candidate</a>"
			recruitment_activity = RecruitmentActivity.create(:message => "#{link}")
			recruitment_activity.message.should eql(link)
		end
	end

end
