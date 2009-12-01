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

	it "should know participants involved" do
		candidate = CandidateFactory.create_registered_with_pairing_and_interview_steps

		pairing = EventFactory.create_in_future
		interview = EventFactory.create_in_future

		candidate.schedule(candidate.recruitment_steps[0], pairing)
		candidate.schedule(candidate.recruitment_steps[1], interview)

		one= Interviewer.create!(:event => pairing, :participant => Participant.create!)
		two= Interviewer.create!(:event => pairing, :participant => Participant.create!)
		three= Interviewer.create!(:event => interview, :participant => Participant.create!)

		candidate.participants.should have(3).things
	end

	it "should know recruiters involved" do
		recruiter = RecruiterFactory.reshmi
		candidate= CandidateFactory.create(:recruiters => [recruiter])
		candidate.save!
		candidate.recruiters.should eql([recruiter])
	end

	describe "recruitment steps" do
		before do
			@pairing_step = RecruitmentStepTypeFactory.pairing
			@interview_step = RecruitmentStepTypeFactory.interview
		end

		describe "recruitment_steps" do
			it "should be all steps" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
				candidate.recruitment_steps.map(&:recruitment_step_type).should == [@pairing_step, @interview_step]
			end
		end

		describe "recruitment_steps_completed" do
			it "should be all past steps" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])

				pairing_event= EventFactory.create_in_past
				interview_event= EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
				candidate.schedule(recruitment_step_for_type(candidate, @interview_step), interview_event)

				candidate.recruitment_steps_completed.map(&:event).should == [pairing_event]
			end
		end

		describe "recruitment_steps_upcoming" do
			it "should be all future steps" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future
				interview_event = EventFactory.create_in_past

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
				candidate.schedule(recruitment_step_for_type(candidate, @interview_step), interview_event)

				candidate.recruitment_steps_upcoming.should have(1).thing
				candidate.recruitment_steps_upcoming.first.recruitment_step_type = @pairing_step
			end
		end

		describe "recruitment_steps_pending" do
			it "should be all future and unscheduled steps" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
				candidate.recruitment_steps_pending.should have(2).things
			end
		end

		describe "recruitment_steps_scheduled" do
			it "should be all steps which have an event" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)

				candidate.recruitment_steps_scheduled.should have(1).things
				candidate.recruitment_steps_scheduled.first.recruitment_step_type = @pairing_step				
			end
		end

		describe "recruitment_steps_unscheduled" do
			it "should be all steps which do not have an event" do
				candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
				pairing_event = EventFactory.create_in_future

				candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)

				candidate.recruitment_steps_unscheduled.should have(1).things
				candidate.recruitment_steps_unscheduled.first.recruitment_step_type = @interview_step				
			end
		end

		describe "feedbacks" do
			it "show be all feedbacks given" do
				pairing = RecruitmentStepFactory.pairing
				pairing_event = EventFactory.create_in_future
				candidate = CandidateFactory.create(:recruitment_steps => [pairing])
				candidate.schedule(pairing, pairing_event)

				Interviewer.create!(:event => pairing_event, :participant => Participant.create!,
														:feedbacks => [Feedback.create(:comment => "Good Candidate")])

				Interviewer.create!(:event => pairing_event, :participant => Participant.create!,
														:feedbacks => [Feedback.create(:comment => "Very Good Candidate")])
				
				candidate.reload.feedbacks.should have(2).things
				candidate.feedbacks.first.comment.should eql("Good Candidate")
				candidate.feedbacks.last.comment.should eql("Very Good Candidate")
			end
		end
	end

	def recruitment_step_for_type(candidate, type)
		candidate.recruitment_steps.select{|step| step.recruitment_step_type == type}.first
	end

end