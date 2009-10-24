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
    candidate = CandidateFactory.create_with_pairing_and_interview_recruitment_steps

    pairing = Event.create!
    interview = Event.create!

    candidate.schedule(candidate.recruitment_steps[0], pairing)
    candidate.schedule(candidate.recruitment_steps[1], interview)
    
    one= Interviewer.create!(:event => pairing, :participant => Participant.create!)
    two= Interviewer.create!(:event => pairing, :participant => Participant.create!)
    three= Interviewer.create!(:event => interview, :participant => Participant.create!)

    candidate.participants.should have(3).things
  end

  it "should know recruiters involved" do
    candidate= CandidateFactory.create(:recruiters => [RecruiterFactory.reshmi])
    candidate.save!
    candidate.recruiters.map(&:login).should == ['reshmi']
  end

  describe "recruitment steps" do

    before do
      @pairing_step = RecruitmentStepTypeFactory.pairing
      @interview_step = RecruitmentStepTypeFactory.interview
    end

    it "returns all steps" do
      candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
      candidate.recruitment_steps.map(&:recruitment_step_type).should == [@pairing_step, @interview_step]
    end

    it "completed returns all past steps" do
      candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])

      pairing_event= EventFactory.create_in_past
      interview_event= EventFactory.create_in_future

      candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
      candidate.schedule(recruitment_step_for_type(candidate, @interview_step), interview_event)

      candidate.recruitment_steps_completed.map(&:event).should == [pairing_event]
    end

    it "pending returns all future and unscheduled steps" do
      candidate = CandidateFactory.create(:recruitment_step_selections => [@pairing_step, @interview_step])
      pairing_event = EventFactory.create_in_future

      candidate.schedule(recruitment_step_for_type(candidate, @pairing_step), pairing_event)
      candidate.recruitment_steps_pending.should have(2).things
    end

    def recruitment_step_for_type(candidate, type)
      candidate.recruitment_steps.select{|step| step.recruitment_step_type == type}.first
    end
  end

end