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
  
  it "should know assigned recruiters" do
      one = RecruiterFactory.create(:name => "maria", :login => 'maria@tw', :email => "maria@tw.com", :primary => true)
      two = RecruiterFactory.create(:name => "reshmi", :login => 'reshmi@tw', :email => "reshmi@tw.com", :primary => false)
      candidate = Candidate.create
      candidate.recruiters << one
      candidate.recruiters << two
      
      candidate.recruiters.should == [one, two]
  end
  
end