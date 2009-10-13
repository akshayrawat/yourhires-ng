require 'spec_helper'

describe Candidate do

  it "should know recruitment steps registered for" do
    candidate = CandidateFactory.create

    pairing = RecruitmentStepType.create
    interview = RecruitmentStepType.create

    candidate.register_for(pairing, interview)

    candidate.recruitment_steps.map(&:recruitment_step_type).should == [pairing, interview]
  end

  it "should know all interviewers involved" do
    candidate = CandidateFactory.create_with_pairing_and_interview_recruitment_steps

    pairing = Event.create(:recruitment_step =>  candidate.recruitment_steps[0])
    interview = Event.create(:recruitment_step => candidate.recruitment_steps[1])

    one = Participant.create
    two = Participant.create
    three = Participant.create

    Interviewer.create(:event => pairing, :participant => one)
    Interviewer.create(:event => pairing, :participant => two)
    Interviewer.create(:event => interview, :participant => three)

    candidate.interviewers.map(&:participant).should == [one, two, three]
  end

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

end