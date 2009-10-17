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
  
  it "is in future if its start date is after now" do
    event = Event.create(:start_time => 10.minutes.from_now, :end_time => 1.hour.from_now)
    event.should be_in_future
  end
  
end