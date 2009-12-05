require File.dirname(__FILE__) + '/../spec_helper'

describe RecruitmentActivityObserver do
  it "should observe candidate and event" do
		observed_classes = RecruitmentActivityObserver.send(:allocate).observed_classes
		
		observed_classes.should have(3).things
    observed_classes.should include(Event, Candidate, Feedback)
  end
end
