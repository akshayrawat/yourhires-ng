require 'spec_helper'

describe Event do
  
  it "should know all assigned interviewers" do
    event = Event.create!
    one = Participant.create!
    two = Participant.create!
    three = Participant.create!
    
    Interviewer.create!(:event => event, :participant => one)
    Interviewer.create!(:event => event, :participant => two)
    
    event.interviewers.map(&:participant).should == [one, two]
  end
end