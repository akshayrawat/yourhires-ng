require 'spec_helper'

describe Event do

	describe "interviewers" do
		it "should be all assigned interviewers" do
			event = EventFactory.create_in_future
			one = ParticipantFactory.create
			two = ParticipantFactory.create
			three = ParticipantFactory.create

			Interviewer.create!(:event => event, :participant => one)
			Interviewer.create!(:event => event, :participant => two)

			event.interviewers.map(&:participant).should == [one, two]
		end
	end

	describe "in_future" do
		it "should be true if start date is after now" do
			event = Event.create(:start_time => 10.minutes.from_now, :end_time => 1.hour.from_now)
			event.should be_in_future
		end	  
	end

	describe "validation" do
		it "should fail validation is no start date or end date specified" do
			event= Event.new(:start_time => nil, :end_time => nil)
			event.should_not be_valid
			event.should have(1).error_on(:start_time)
			event.should have(1).error_on(:end_time)
		end	  
	end

	describe "interviewer_selections" do
		it "should add participants " do
			event = EventFactory.create_in_future
			one = ParticipantFactory.create
			two = ParticipantFactory.create
			event.interviewer_selections = [one, two]
			event.interviewers.map(&:participant).should == [one, two]
		end
	end

	describe "interviewer_deselections" do
		it "should add participants " do
			event = EventFactory.create_in_future
			one = ParticipantFactory.create
			two = ParticipantFactory.create
			event.interviewer_selections = [one, two]
			event.save
			event.interviewer_deselections = event.interviewers.collect(&:id)
			event.interviewers.should be_empty
		end
	end

end