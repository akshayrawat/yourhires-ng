require 'spec_helper'

describe Feedback do

	it "should be invaid when no comments given" do
		feedback= Feedback.new(:comment => "")
		feedback.errors_on(:comment).should_not be_blank
	end
end
