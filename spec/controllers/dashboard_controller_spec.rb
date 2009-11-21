require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
	integrate_views

	before(:each) do
		@maria = RecruiterFactory.maria
		login_as @maria    
	end

	context "#index" do
		context "upcoming event section" do
			it "should list first 5 upcoming events for the recruiter" do
				candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

				one = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)

				two = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)
				three = RecruitmentStepFactory.phone_interview(:event => EventFactory.create_in_future)
				four = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_future)
				five = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)
				six = RecruitmentStepFactory.phone_interview(:event => EventFactory.create_in_future)
				seven = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_future)

				candidate.recruitment_steps = [one, two, three, four, five, six, seven]

				get :index

				assigns(:upcoming_events).should have(5).things

				response.should_not have_tag("*[id=?]", "event_#{one.event.id}")
				response.should have_tag("*[id=?]", "event_#{two.event.id}")
				response.should have_tag("*[id=?]", "event_#{three.event.id}")
				response.should have_tag("*[id=?]", "event_#{four.event.id}")
				response.should have_tag("*[id=?]", "event_#{five.event.id}")
				response.should have_tag("*[id=?]", "event_#{six.event.id}")
				response.should_not have_tag("*[id=?]", "event_#{seven.event.id}")
			end

			it "should show the event detail for the first event" do
				candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

				one = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_future)
				two = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)
				candidate.recruitment_steps = [one, two]

				get :index

				response.should have_tag("*[id=?]", "detail_event_#{one.event.id}")
			end
		end	
		
		context "recent activities section" do
			it "should list recent recruitment activities" do
				candidate = CandidateFactory.create(:recruiters => [@maria])
			  RecruitmentActivity.create(:candidate => candidate,:recruiter => @maria, :message => "candidate was created")
			
				get :index
				
				response.should have_tag(".recruitment-activity .message", "candidate was created")
			end
		end	
	end
end
