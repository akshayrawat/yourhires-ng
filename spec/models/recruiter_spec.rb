require 'spec_helper'

describe Recruiter do
	
	it "should know assigned recruiters" do
		recruiter = RecruiterFactory.maria
		one= CandidateFactory.create(:recruiters=> [recruiter])
		two= CandidateFactory.create(:recruiters=> [recruiter])

		recruiter.save!

		recruiter.candidates.should == [one, two]
	end

	it "should fail validation when mandatory fields are not specified" do
		recruiter= Recruiter.new

		recruiter.should_not be_valid
		recruiter.should have(1).error_on(:name)
		recruiter.should have(3).error_on(:email)
		recruiter.should have(3).error_on(:login)
	end

	it "should know upcoming events" do
		maria = RecruiterFactory.maria
		pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)
		interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

		candidate= CandidateFactory.create(:name => "Arnab", 
		:recruiters => [maria], :recruitment_steps => [pairing, interview])

		maria.upcoming_events.should have(1).thing            
		maria.upcoming_events.first.recruitment_step.should eql(interview)
	end
	
	it "should know completed events" do
		maria = RecruiterFactory.maria
		pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)
		interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

		candidate= CandidateFactory.create(:name => "Arnab", 
		:recruiters => [maria], :recruitment_steps => [pairing, interview])

		maria.completed_events.should have(1).thing            
		maria.completed_events.first.recruitment_step.should eql(pairing)	  
	end

	it "should know unscheduled recruitment steps" do
		maria = RecruiterFactory.maria
		pairing = RecruitmentStepFactory.pairing
		interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

		candidate= CandidateFactory.create(:name => "Arnab", 
		:recruiters => [maria], :recruitment_steps => [pairing, interview])

		maria.reload
		maria.unscheduled_recruitment_steps.should have(1).thing
		maria.unscheduled_recruitment_steps.first.should eql(pairing)
	end

end