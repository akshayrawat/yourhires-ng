require 'spec_helper'

describe Candidate do

	it "should have candidate fields" do
		candidate= Candidate.create(
		:role => Role.create(:name => "Developer"),
		:email => "foo@bar.com",
		:phone => "12345678"
		)

		candidate.role.name.should eql("Developer")
		candidate.email.should eql("foo@bar.com")
		candidate.phone.should eql("12345678")
	end

	it "should fail validation when mandatory fields are not specified" do
		candidate= Candidate.new

		candidate.should_not be_valid
		candidate.should have(1).error_on(:name)
		candidate.should have(1).error_on(:phone)
		candidate.should have(1).error_on(:email)
		candidate.should have(1).error_on(:source)
		candidate.should have(1).error_on(:role_id)
		candidate.should have(1).error_on(:recruiters)
		candidate.should have(1).error_on(:recruitment_steps)
	end

	describe "participants" do
		it "should be all interviewer participants in all events" do
			candidate = CandidateFactory.create_registered_with_pairing_and_interview_steps

			pairing = EventFactory.create_in_future
			interview = EventFactory.create_in_future

			candidate.schedule(candidate.recruitment_steps[0], pairing)
			candidate.schedule(candidate.recruitment_steps[1], interview)

			Interviewer.create!(:event => pairing, :participant => (one = ParticipantFactory.create))
			Interviewer.create!(:event => pairing, :participant => (two = ParticipantFactory.create))
			Interviewer.create!(:event => interview, :participant => (three = ParticipantFactory.create))

			candidate.participants.should have(3).things
			candidate.participants.should eql([one, two, three])
		end
	end

	describe "interviewers" do
		it "should be all interviewers in all events" do
			candidate = CandidateFactory.create_registered_with_pairing_and_interview_steps

			pairing = EventFactory.create_in_future
			interview = EventFactory.create_in_future

			candidate.schedule(candidate.recruitment_steps[0], pairing)
			candidate.schedule(candidate.recruitment_steps[1], interview)

			one= Interviewer.create!(:event => pairing, :participant => ParticipantFactory.create)
			two= Interviewer.create!(:event => pairing, :participant => ParticipantFactory.create)
			three= Interviewer.create!(:event => interview, :participant => ParticipantFactory.create)

			candidate.interviewers.should have(3).things
			candidate.interviewers.should eql([one, two, three])
		end
	end

	describe "recruiters" do
		it "should be ones assigned" do
			recruiter = RecruiterFactory.reshmi
			candidate= CandidateFactory.create(:recruiters => [recruiter])
			candidate.save!
			candidate.recruiters.should eql([recruiter])
		end
	end

	describe "recruitment steps" do
		before do
			@pairing_step = RecruitmentStepTypeFactory.pairing
			@interview_step = RecruitmentStepTypeFactory.interview
		end

		describe "recruitment_steps" do
			it "should be all steps" do
				candidate = CandidateFactory.create(:recruitment_step_type_selections => [@pairing_step, @interview_step])
				candidate.recruitment_steps.map(&:recruitment_step_type).should == [@pairing_step, @interview_step]
			end
		end

		describe "recruitment_steps_completed" do
			it "should be all past steps" do
				candidate = CandidateFactory.create(:recruitment_step_type_selections => [@pairing_step, @interview_step])

				pairing_event= EventFactory.create_in_past
				interview_event= EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
				candidate.schedule(recruitment_step_for_type(candidate, @interview_step), interview_event)

				candidate.recruitment_steps_completed.map(&:event).should == [pairing_event]
			end
		end

		describe "recruitment_steps_upcoming" do
			it "should be all future steps" do
				candidate = CandidateFactory.create(:recruitment_step_type_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future
				interview_event = EventFactory.create_in_past

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
				candidate.schedule(recruitment_step_for_type(candidate, @interview_step), interview_event)

				candidate.recruitment_steps_upcoming.should have(1).thing
				candidate.recruitment_steps_upcoming.first.recruitment_step_type = @pairing_step
			end
		end

		describe "recruitment_steps_scheduled" do
			it "should be all steps which have an event" do
				candidate = CandidateFactory.create(:recruitment_step_type_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)

				candidate.recruitment_steps_scheduled.should have(1).things
				candidate.recruitment_steps_scheduled.first.recruitment_step_type = @pairing_step				
			end
		end

		describe "recruitment_steps_unscheduled" do
			it "should be all steps which do not have an event" do
				candidate = CandidateFactory.create(:recruitment_step_type_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)

				candidate.recruitment_steps_unscheduled.should have(1).things
				candidate.recruitment_steps_unscheduled.first.recruitment_step_type = @interview_step
			end
		end

		describe "feedbacks" do
			it "show be all feedbacks in the order of updated_at descending" do
				pairing = RecruitmentStepFactory.pairing
				pairing_event = EventFactory.create_in_future
				candidate = CandidateFactory.create(:recruitment_steps => [pairing])
				candidate.schedule(pairing, pairing_event)

				one = Interviewer.create!(:event => pairing_event, :participant => ParticipantFactory.create)
				two = Interviewer.create!(:event => pairing_event, :participant => ParticipantFactory.create)
				FeedbackFactory.create(:updated_at => 1.hour.ago, :comment => "Very Good Candidate", :interviewer => one)
				FeedbackFactory.create(:updated_at => 1.minute.ago, :comment => "Good Candidate", :interviewer => two)

				candidate.reload.feedbacks.should have(2).things
				candidate.feedbacks.first.comment.should eql("Good Candidate")
				candidate.feedbacks.last.comment.should eql("Very Good Candidate")
			end
		end
	end

	describe "recruitment_step_deselections" do
		it "removes recruitment step" do
			pairing = RecruitmentStepTypeFactory.pairing
			candidate = CandidateFactory.create(:recruitment_step_type_selections => [pairing])
			candidate.recruitment_steps.should have(1).thing
			candidate.recruitment_step_deselections= pairing.id
			RecruitmentStep.exists?(pairing.id).should be_false
		end
	end
	
	describe "recruiter_step_selection" do
	  it "adds recruiter" do
			recruiter = RecruiterFactory.maria
			candidate = CandidateFactory.build(:recruiters => [])
			candidate.recruiter_selections = [recruiter]
			candidate.recruiters.should == [recruiter]
	  end
	end
	
	describe "recruiter_step_deselection" do
	  it "removes recruiter" do
			recruiter = RecruiterFactory.maria
			candidate = CandidateFactory.build(:recruiters => [recruiter])
			candidate.recruiter_deselections = [recruiter]
			candidate.recruiters.should be_empty
	  end
	end

	def recruitment_step_for_type(candidate, type)
		candidate.recruitment_steps.select{|step| step.recruitment_step_type == type}.first
	end

end