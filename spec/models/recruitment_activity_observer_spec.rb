require File.dirname(__FILE__) + '/../spec_helper'

describe RecruitmentActivityObserver do
  it "should observe candidate and event" do
    RecruitmentActivityObserver.send(:allocate).observed_classes.should include(Event, Candidate)
  end
end
