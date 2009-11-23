require File.dirname(__FILE__) + '/../spec_helper'

describe RecruitmentActivity do

	describe "for candidates" do
		it "should create a new instance for a new candidate activity" do
			candidate = CandidateFactory.create
			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.new_candidate(candidate)

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.recruiter.should eql(recruiter)
			activity.message.should_not be_blank
		end

		it "should create a new instance for a update candidate activity" do
			candidate = CandidateFactory.create
			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.candidate_updated(candidate)

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.recruiter.should eql(recruiter)
			activity.message.should_not be_blank
		end
	end

	describe "for events" do
		it "should create a new instance for a new event activity" do
			event = EventFactory.create
			pairing = RecruitmentStepFactory.pairing(:event => event)
			candidate= CandidateFactory.create
			candidate.recruitment_steps = [pairing]

			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.new_event(event)

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.recruiter.should eql(recruiter)
			activity.message.should_not be_blank			
		end	

		it "should create a new instance for a update event activity" do
			event = EventFactory.create
			pairing = RecruitmentStepFactory.pairing(:event => event)
			candidate= CandidateFactory.create
			candidate.recruitment_steps = [pairing]

			recruiter = candidate.recruiters.first
			RecruiterSession.expects(:find).returns(stub(:recruiter => recruiter))
			RecruitmentActivity.event_updated(event)

			activity = RecruitmentActivity.find_by_candidate_id(candidate)
			activity.recruiter.should eql(recruiter)
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

end
