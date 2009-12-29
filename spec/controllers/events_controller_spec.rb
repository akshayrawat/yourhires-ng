require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
	integrate_views

	before(:each) do
		@maria = RecruiterFactory.maria
		login_as @maria
	end

	describe "index" do
		it "should list upcoming events for recruiter" do
			candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

			pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)
			interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

			candidate.recruitment_steps = [pairing, interview]

			get :index

			response.should have_tag("*[id=?]", interview.event.id)
			response.should_not have_tag("*[id=?]", pairing.event.id)
		end
	end

	describe "new" do
		it "should render fields for create" do
			candidate = CandidateFactory.create(:name => "Karan", :recruiters => [@maria], 
			:recruitment_steps => [RecruitmentStepFactory.phone_interview])
			
			recruitment_step = candidate.recruitment_steps.first
			get :new, :candidate_id=> candidate.id, :recruitment_step_id => recruitment_step.id
			
			response.body.should include(recruitment_step.name)
			response.should have_tag("input[type=hidden][value=?]", recruitment_step.id)
			response.should have_tag("input[type=text][name='event[venue]']")
			response.should have_tag("select[name='event[start_time(3i)]']")
			response.should have_tag("select[name='event[end_time(3i)]']")
			response.should have_tag("textarea[name='event[comment]']")
		end
	end
	
	describe "show" do
		it "should render event details template when request is non xhr" do
			event = EventFactory.create(:venue => "Room 301")
			CandidateFactory.create(:recruitment_steps => [RecruitmentStepFactory.pairing(
			:event => event)])

			get :show, :id => event.id
			
			response.should have_tag('.events')
			response.body.should match("Room 301")
		end

		it "should render event details partial when request is xhr" do
			event = EventFactory.create(:venue => "Room 301")
			CandidateFactory.create(:recruitment_steps => [RecruitmentStepFactory.pairing(
			:event => event)])

			xhr :get, :show, :id => event.id
			
			response.should_not have_tag('.events')
			response.body.should match("Room 301")
		end

	end

end