require 'spec_helper'

describe EventIcalGeneration do
	
	context "generate_ical" do
		it "should return ical for events" do
			ical_generator = Object.new.extend(EventIcalGeneration)
			
		  candidate = CandidateFactory.create(:recruitment_steps => 
									[RecruitmentStepFactory.pairing(:event => (event= EventFactory.create))])

			icalendar = ical_generator.generate_ical([event])
			
			icalendar.should include("BEGIN:VCALENDAR")
			icalendar.should include("BEGIN:VEVENT")
			icalendar.should include("LOCATION:#{event.venue}")
			icalendar.should include("END:VEVENT")
			icalendar.should include("END:VCALENDAR")			
		end
	end
  
end
