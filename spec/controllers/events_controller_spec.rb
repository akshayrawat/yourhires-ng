require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
	integrate_views

	before(:each) do
		@maria = RecruiterFactory.maria
		login_as @maria
	end

	context "index" do
		it "should list upcoming events for recruiter" do
			candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

			pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)
			interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

			candidate.recruitment_steps = [pairing, interview]

			get :index

			response.should have_tag('.event-title a', 
																:text => "#{interview.name}:", 
																:href => event_detail_url(interview.candidate, interview.id))
																
			response.should have_tag('.event-title a',
																:text => candidate.name,
																:href => candidate_url(candidate))

			response.should have_tag('.event-title a',
																:text => "[edit]",
																:href => edit_candidate_recruitment_step_event_url(interview.candidate, interview, interview.event))
																
			response.should_not have_tag('.event-title a', :text => "#{pairing.name}:")
		end
	end
	
	context "events_completed" do
	  it "should list events completed for recruiter" do
			candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

			pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create(:interviewers => [Interviewer.create!(:feedbacks => [Feedback.create!(:feedback_result => Feedback::FeedbackResult::PASS)], :participant => ParticipantFactory.create)], :start_time=> 10.minutes.ago))
			interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

			candidate.recruitment_steps = [pairing, interview]
			
			get :events_completed

			response.should have_tag('.event-title a', 
																:text => "#{pairing.name}:",
																:href => event_detail_url(pairing.candidate, pairing.id))
																
			response.should have_tag('.event-title a',
																:text => candidate.name,
																:href => candidate_url(candidate))

			response.should have_tag('.event-title a',
																:text => "[edit]",
																:href => edit_candidate_recruitment_step_event_url(pairing.candidate, pairing, pairing.event))
			
			response.should have_tag("a[href=#{candidate_recruitment_step_event_feedbacks_url(candidate, pairing, pairing.event)}]", :text => "Read Feedbacks")
																
			response.should_not have_tag('.event-title a', :text => "#{interview.name}:")
 		end
	end
	
	context "events_unscheduled" do
	  it "should list unschedule recruitment steps for recruiter" do
			candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

			pairing = RecruitmentStepFactory.pairing
			interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

			candidate.recruitment_steps = [pairing, interview]

			get :events_unscheduled

			response.should have_tag('.event-title a', 
																:text => "#{pairing.name}:",
																:href => event_detail_url(pairing.candidate, pairing.id))
																
			response.should have_tag('.event-title a',
																:text => candidate.name,
																:href => candidate_url(candidate))

			response.should have_tag(".event-title a[href=#{new_candidate_recruitment_step_event_url(candidate, pairing)}]",
																:text => "[schedule]")

			response.should_not have_tag('.event-title a', :text => "#{interview.name}:")
	  end
	end

	context "new" do
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
	
	context "show" do
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