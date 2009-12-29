require 'spec_helper'

describe Feedback do

	it "should be sort by update_at descending" do
		two= Feedback.new(:updated_at => 1.hour.ago)
		three = Feedback.new(:updated_at => 1.day.ago)
		one = Feedback.new(:updated_at => 1.minutes.ago)

		[two, three, one].sort.should eql([one, two, three])
	end

	it "fail validation when no feedback_result specified" do
		feedback= Feedback.new(:feedback_result => nil)
		feedback.should have(1).error_on(:feedback_result)
	end

	it "save and load enum as active record attributes" do
		feedback= Feedback.create(:feedback_result => Feedback::FeedbackResult::PASS)
		feedback.reload
		feedback.feedback_result.should eql(Feedback::FeedbackResult::PASS)
	end
end
