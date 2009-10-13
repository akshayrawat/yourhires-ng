require File.dirname(__FILE__) + '/../spec_helper'

describe CandidatesController do
  
  context "for logged in recruiter" do
    it "should list candidates assigned" do
      
      one = Recruiter.create(:candidates  => [Candidate.create(:name => "Foo"), Candidate.create(:name => "Bar")])
      two = Recruiter.create(:candidates  => [Candidate.create(:name => "Baz")])
    end
    
    it "should list all candidates" do
    end

    it "should list candidates watched" do
    end
    
    
  end
  
end
