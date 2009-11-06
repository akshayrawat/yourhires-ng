require 'spec_helper'

describe Event do
  
  it "should know all assigned interviewers" do
    event = EventFactory.create_in_future
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
  
  it "should fail validation is no start date or end date specified" do
    event= Event.new(:start_time => nil, :end_time => nil)
    event.should_not be_valid
    event.should have(1).error_on(:start_time)
    event.should have(1).error_on(:end_time)
  end
  
end