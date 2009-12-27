require 'spec_helper'

describe Participant do

	context "validation" do
		it "should fail when no email specified" do
			participant = Participant.new(:email => nil)
			participant.should have(1).errors_on(:email)
		end
	end
end
