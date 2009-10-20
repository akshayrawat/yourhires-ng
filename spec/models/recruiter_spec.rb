require 'spec_helper'

describe Recruiter do
  it "should know assigned candidates" do
      recruiter = RecruiterFactory.create(:name => "maria", :login => 'maria@tw', :email => "maria@tw.com")
      one= CandidateFactory.create
      two= CandidateFactory.create

      recruiter.candidates << one
      recruiter.candidates << two
      
      recruiter.candidates.should == [one, two]
  end
  
end