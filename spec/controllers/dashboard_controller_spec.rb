require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
	integrate_views

	before(:each) do
		@maria = RecruiterFactory.maria
		login_as @maria    
	end

	context "index" do
		context "upcoming event section" do
			it "should list first 5 upcoming events for the recruiter" do
				candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

				one = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)

				two = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)
				three = RecruitmentStepFactory.phone_interview(:event => EventFactory.create_in_future)
				four = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_future)
				five = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)
				six = RecruitmentStepFactory.phone_interview(:event => EventFactory.create_in_future)
				seven = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)

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
				RecruitmentActivity.create(:candidate => candidate, :posted_by => @maria.name, :message => "candidate was created")

				get :index

				response.should have_tag(".recruitment-activity .message", "candidate was created")
			end
		end	

		context "sidebar section" do
			it "should display roles_in_pipeline statistics" do
				developer, ba, qa = RoleFactory.developer, RoleFactory.ba, RoleFactory.qa
			  2.times {CandidateFactory.create(:role => developer)}
			  3.times {CandidateFactory.create(:role => ba)}
			  5.times {CandidateFactory.create(:role => qa)}
				
				get :index
				
				response.should have_tag("li", :text => "#{RoleFactory.developer.name}: 2")
				response.should have_tag("li", :text => "#{RoleFactory.ba.name}: 3")
				response.should have_tag("li", :text => "#{RoleFactory.qa.name}: 5")
			end

			it "should display recruiting_sources statistics" do
			  2.times {CandidateFactory.create(:source => "Direct")}
			  3.times {CandidateFactory.create(:source => "Referral")}
			  5.times {CandidateFactory.create(:source => "Monster")}

				get :index
				
				response.should have_tag("li", :text => "Direct: 2")
				response.should have_tag("li", :text => "Referral: 3")
				response.should have_tag("li", :text => "Monster: 5")
			end

			it "should display steps_pending_in_pipeline statistics" do
				pairing = RecruitmentStepTypeFactory.pairing 
				phone_interview = RecruitmentStepTypeFactory.phone_interview
				interview = RecruitmentStepTypeFactory.interview

			  2.times {RecruitmentStepFactory.create(:recruitment_step_type => pairing)}
			  3.times {RecruitmentStepFactory.create(:recruitment_step_type => phone_interview)}
			  5.times {RecruitmentStepFactory.create(:recruitment_step_type => interview)}

				get :index
				
				response.should have_tag("li", :text => "#{pairing.name}: 2")
				response.should have_tag("li", :text => "#{phone_interview.name}: 3")
				response.should have_tag("li", :text => "#{interview.name}: 5")
			end
		end
	end
end
