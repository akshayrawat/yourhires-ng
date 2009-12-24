require 'spec_helper'

describe EventsHelper do

	before(:each) do
		@helper = Object.new.extend(EventsHelper)
	end

	describe "event_title_class" do
		it "should be 'completed-event-title' when recruitment step is completed" do
			@helper.event_title_class(stub_everything(:completed? => true)).should eql("completed-event-title")
		end

		it "should be 'upcoming-event-title' when recruitment step is upcoming" do
			@helper.event_title_class(stub_everything(:upcoming? => true)).should eql("upcoming-event-title")
		end

		it "should be 'unscheduled-event-title' when recruitment step is unscheduled" do
			@helper.event_title_class(stub_everything(:unscheduled? => true)).should eql("unscheduled-event-title")
		end
	end
end
