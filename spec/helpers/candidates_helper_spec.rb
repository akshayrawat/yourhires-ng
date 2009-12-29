require 'spec_helper'

describe CandidatesHelper do

	context "feedback_result_class" do
		
		before(:each) do
				@helper = Object.new.extend(CandidatesHelper)
		end
		
		it "should be 'undecided' when all feedback results are undecided" do
			event= Event.create(:interviewers  => [
				Interviewer.create(:feedbacks => [
					FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::UNDECIDED),
					 FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::UNDECIDED)
					])])
					
			@helper.feedback_result_class(event).should eql('undecided')
		end

		it "should be 'pursue' when all feedback results except 'undecided' are pursue" do
			event= Event.create(:interviewers  => [
				Interviewer.create(:feedbacks => [
					FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::UNDECIDED),
					 FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::PURSUE)
					])])
					
			@helper.feedback_result_class(event).should eql('pursue')
		end

		it "should be 'pass' when any one of the results is a 'pass'" do
			event= Event.create(:interviewers  => [
				Interviewer.create(:feedbacks => [
					FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::PASS),
					 FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::PURSUE),
					 FeedbackFactory.create(:feedback_result => Feedback::FeedbackResult::UNDECIDED)
					])])
					
			@helper.feedback_result_class(event).should eql('pass')
		end
	end

end
