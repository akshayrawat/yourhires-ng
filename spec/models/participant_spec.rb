require 'spec_helper'

describe Participant do

	context "validation" do
		it "should fail when no email specified" do
			participant = Participant.new(:email => nil)
			participant.should have(1).errors_on(:email)
		end

		it "should fail when no name specified" do
			participant = Participant.new(:name => nil)
			participant.should have(1).errors_on(:name)
		end
	end
end
