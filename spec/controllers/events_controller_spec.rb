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
		it "should list all recruitment steps for specified candidate" do
			candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])
			CandidateFactory.create(:name => "Karan", :recruiters => [@maria], 
			:recruitment_steps => [RecruitmentStepFactory.phone_interview])

			pairing = RecruitmentStepFactory.pairing
			interview = RecruitmentStepFactory.interview

			candidate.recruitment_steps = [pairing, interview]

			get :new, :candidate_id=> candidate.id

			response.should have_tag("span", interview.recruitment_step_type.name)
			response.should have_tag("span", pairing.recruitment_step_type.name)
			response.should_not have_tag("span", RecruitmentStepTypeFactory.phone_interview.name)
		end

		it "should list current recruiter`s candidates in select box" do
			candidate_one = CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])
			candidate_two= CandidateFactory.create(:name=> "Karan",:recruiters=> [RecruiterFactory.reshmi])

			get :new

			response.should have_tag("select#selected_candidate_id option", candidate_one.name)
			response.should_not have_tag("select#selected_candidate_id option", candidate_two.name)
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