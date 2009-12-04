require 'spec_helper'

describe FeedbacksController do
	include HelperSupport
	integrate_views

	context "index" do
		it "should render feedbacks for candidate" do
			candidate= CandidateFactory.create(:recruitment_step_selections => [RecruitmentStepTypeFactory.pairing])

			pairing_event= EventFactory.create(
			:interviewers => [Interviewer.create!(:participant => Participant.create!,
				:feedbacks => [
					Feedback.create(:comment => "First good comment"),
					Feedback.create(:comment => "Second good comment")
					])])

					candidate.schedule(candidate.recruitment_steps.first, pairing_event)

					login_as RecruiterFactory.maria

					get :index, :candidate_id => candidate.id

					response.body.should include("First good comment")
					response.body.should include("Second good comment")
				end
			end

			context "new" do

				it "should render form for feedback creation" do
					candidate= CandidateFactory.create(:recruitment_step_selections => [RecruitmentStepTypeFactory.pairing])

					pairing_event= EventFactory.create(
					:interviewers => [Interviewer.create!(:participant => Participant.create!(:name => "Suresh")),
						Interviewer.create!(:participant => Participant.create!(:name => "Nilakanta"))])

						candidate.schedule(candidate.recruitment_steps.first, pairing_event)

						login_as RecruiterFactory.maria

						get :new, :candidate_id => candidate.id

						response.should have_tag("#feedback_comment")
						response.should have_tag("form[action=?]", candidate_feedbacks_path(candidate))
						response.should have_tag("select#feedback_interviewer")
						helper_instance(FeedbacksHelper).select_interviewer_options(candidate).each do |option|
							response.should have_tag("select#feedback_interviewer option", option.first)
						end
						
					end
				end
			end
