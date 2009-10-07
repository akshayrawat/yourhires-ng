require 'spec_helper'

describe RecruitmentStep do
  
  it "should know assigned candidate and recruitment step type" do
    candidate = CandidateFactory.create
    recruitment_step_type = RecruitmentStepType.create
    recruitment_step = RecruitmentStep.create!(:candidate => candidate, :recruitment_step_type => recruitment_step_type)
    
    recruitment_step.candidate.should eql(candidate)
    recruitment_step.recruitment_step_type.should eql(recruitment_step_type)
  end
  
end
