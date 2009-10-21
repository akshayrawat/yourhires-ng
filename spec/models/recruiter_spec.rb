require 'spec_helper'

describe Recruiter do
  it "should know assigned recruiters" do
      recruiter = RecruiterFactory.create(:name => "maria", :login => 'maria@tw', :email => "maria@tw.com")
      one= CandidateFactory.create
      two= CandidateFactory.create

      recruiter.candidates = [one, two]
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
  
end