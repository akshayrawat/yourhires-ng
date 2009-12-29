require 'spec_helper'

describe FeedbacksController do
	include HelperSupport
	integrate_views

	before(:each) do
		login_as RecruiterFactory.maria
	end

	describe "index" do
		it "should render feedbacks for event" do
			candidate= CandidateFactory.create(:recruitment_step_type_selections => [RecruitmentStepTypeFactory.pairing])

			pairing_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create,
				:feedbacks => [
					FeedbackFactory.create(:comment => "First good comment"),
					FeedbackFactory.create(:comment => "Second good comment")
					])])

			interview_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create,
				:feedbacks => [
					FeedbackFactory.create(:comment => "interview comment")
					])])

			candidate.schedule(candidate.recruitment_steps.first, pairing_event)

			get :index, :candidate_id => candidate.id, :event_id => pairing_event

			response.body.should include("First good comment")
			response.body.should include("Second good comment")
			response.body.should_not include("interview comment")
		end

		it "should render feedbacks for candidate when no event specified" do
			candidate= CandidateFactory.create(:recruitment_step_type_selections => [RecruitmentStepTypeFactory.pairing, RecruitmentStepTypeFactory.interview])

			pairing_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create,
				:feedbacks => [
					FeedbackFactory.create(:comment => "First good comment"),
					FeedbackFactory.create(:comment => "Second good comment")
					])])

			interview_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create,
				:feedbacks => [
					FeedbackFactory.create(:comment => "interview comment")
					])])

			candidate.schedule(candidate.recruitment_steps.first, pairing_event)
			candidate.schedule(candidate.recruitment_steps.last, interview_event)

			get :index, :candidate_id => candidate.id

			response.body.should include("First good comment")
			response.body.should include("Second good comment")
			response.body.should include("interview comment")
		end
	end

	describe "new" do
		it "should render form for feedback creation" do
			candidate= CandidateFactory.create(:recruitment_step_type_selections => [RecruitmentStepTypeFactory.pairing])

			pairing_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create(:name => "Suresh")),
			Interviewer.create!(:participant => ParticipantFactory.create(:name => "Nilakanta"))])

			candidate.schedule(candidate.recruitment_steps.first, pairing_event)

			get :new, :candidate_id => candidate.id

			response.should have_tag("#feedback_comment")
			response.should have_tag("form[action=?]", candidate_feedbacks_path(candidate))
			response.should have_tag("select#feedback_interviewer_id")
			helper_instance(FeedbacksHelper).select_interviewer_options(candidate).each do |option|
				response.should have_tag("select#feedback_interviewer_id option", option.first)
			end
		end
	end

	describe "update" do
		it "should render form for feedback updation" do
			candidate= CandidateFactory.create(:recruitment_step_type_selections => [RecruitmentStepTypeFactory.pairing])
			feedback = FeedbackFactory.create(:comment => "Good Candidate")
			pairing_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => ParticipantFactory.create(:name => "Suresh")),
			Interviewer.create!(:participant => ParticipantFactory.create(:name => "Nilakanta"), :feedbacks => [feedback])])

			candidate.schedule(candidate.recruitment_steps.first, pairing_event)

			get :edit, :candidate_id => candidate.id, :id => feedback

			response.should have_tag("#feedback_comment")
			response.should have_tag("form[action=?]", candidate_feedback_path(candidate, feedback))
			response.should have_tag("select#feedback_interviewer_id")
			helper_instance(FeedbacksHelper).select_interviewer_options(candidate).each do |option|
				response.should have_tag("select#feedback_interviewer_id option", option.first)
			end
		end
	end

	describe "create" do
		it "should save a new feedback" do
			post :create, :candidate_id => CandidateFactory.create, 
			:feedback => {:interviewer_id => (interviewer = Interviewer.create!).id, :comment => "My Honest Feedback", :feedback_result => Feedback::FeedbackResult::PASS}

			interviewer.reload.feedbacks.should have(1).thing
			interviewer.feedbacks.first.comment.should eql("My Honest Feedback")
		end

		it "should redirect to index" do
			post :create, :candidate_id => (candidate = CandidateFactory.create), 
			:feedback => {:interviewer_id => Interviewer.create!.id, :comment => "My Honest Feedback", :feedback_result => Feedback::FeedbackResult::PASS}
			response.should redirect_to(candidate_feedbacks_url())
		end
	end

	describe "update" do
		it "should update feedback" do
			feedback = FeedbackFactory.create(:comment => "Good Candidate", :interviewer => (interviewer = Interviewer.create))
			post :update, :candidate_id => CandidateFactory.create, :id => feedback.id,
			:feedback => {:interviewer_id => interviewer.id, :comment => "My Honest Feedback", :feedback_result => Feedback::FeedbackResult::PASS}

			interviewer.reload.feedbacks.should have(1).thing
			interviewer.feedbacks.first.comment.should eql("My Honest Feedback")
		end

		it "should redirect to index" do
			feedback = FeedbackFactory.create(:comment => "Good Candidate", :interviewer => (interviewer = Interviewer.create))
			post :update, :candidate_id => CandidateFactory.create, :id => feedback.id,
			:feedback => {:interviewer_id => interviewer.id, :comment => "My Honest Feedback"}

			response.should redirect_to(candidate_feedbacks_url())
		end
	end
end
