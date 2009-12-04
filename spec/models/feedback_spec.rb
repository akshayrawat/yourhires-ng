require 'spec_helper'

describe Feedback do

	it "should be sort by update_at descending" do
		two= Feedback.new(:updated_at => 1.hour.ago)
		three = Feedback.new(:updated_at => 1.day.ago)
		one = Feedback.new(:updated_at => 1.minutes.ago)
		
		[two, three, one].sort.should eql([one, two, three])
	end
end
