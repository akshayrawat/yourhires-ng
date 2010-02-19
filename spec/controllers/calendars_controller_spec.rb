require 'spec_helper'

describe CalendarsController do

	context "show" do
		it "should be accessable without login" do
			get :show, :format => "ics"
			response.code.should eql("200")
		end

		it "should respond with 'Bad Request' for non ics formats" do
			%(xml html js).each do |format|
				get :show, :format => format
				response.code.should eql("400")
			end
		end

		it "should render icalendar for all events" do
			candidate = CandidateFactory.create(:recruitment_steps => 
									[RecruitmentStepFactory.pairing(:event => (event= EventFactory.create))])

			get :show, :format => "ics"
			response.body.should include("BEGIN:VCALENDAR")
			response.body.should include("BEGIN:VEVENT")
			response.body.should include("LOCATION:#{event.venue}")
			response.body.should include("END:VEVENT")
			response.body.should include("END:VCALENDAR")
		end
	end

end
