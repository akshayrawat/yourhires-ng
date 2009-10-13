require File.dirname(__FILE__) + '/../spec_helper'

describe CandidatesController do

  context "for logged in recruiter" do
    it "should list candidates assigned" do
      one = RecruiterFactory.create(:candidates  => [Candidate.create(:name => "Foo"), Candidate.create(:name => "Bar")])
      
    end

    it "should list all candidates" do
    end

    it "should list candidates watched" do
    end


  end

end
