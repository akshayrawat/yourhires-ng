require 'spec_helper'

describe FeedbacksController do
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
end
