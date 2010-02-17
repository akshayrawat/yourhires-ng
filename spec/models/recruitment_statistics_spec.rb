require 'spec_helper'

describe RecruitmentStatistics do
  
	it "should build statistics for roles in pipeline" do
		developer, ba, qa = RoleFactory.developer, RoleFactory.ba, RoleFactory.qa
	  2.times {CandidateFactory.create(:role => developer)}
	  3.times {CandidateFactory.create(:role => ba)}
	  5.times {CandidateFactory.create(:role => qa)}
	
		statistics = RecruitmentStatistics.roles_in_pipeline
		
		statistics["#{developer.id}"].should eql("2")
		statistics["#{ba.id}"].should eql("3")
		statistics["#{qa.id}"].should eql("5")
	end
	
	it "should build statistics for recruitment sources" do
	  2.times {CandidateFactory.create(:source => "Direct")}
	  3.times {CandidateFactory.create(:source => "Referral")}
	  5.times {CandidateFactory.create(:source => "Monster")}
	
		statistics = RecruitmentStatistics.recruiting_sources

		statistics["Direct"].should eql("2")
		statistics["Referral"].should eql("3")
		statistics["Monster"].should eql("5")
	end
	
	it "should build statistics for recruitment steps pending in pipeline" do
		pairing = RecruitmentStepTypeFactory.pairing 
		phone_interview = RecruitmentStepTypeFactory.phone_interview
		interview = RecruitmentStepTypeFactory.interview
		
	  2.times {RecruitmentStepFactory.create(:recruitment_step_type => pairing)}
	  3.times {RecruitmentStepFactory.create(:recruitment_step_type => phone_interview)}
	  5.times {RecruitmentStepFactory.create(:recruitment_step_type => interview)}

		statistics = RecruitmentStatistics.steps_pending_in_pipeline

		statistics["#{pairing.id}"].should eql("2")
		statistics["#{phone_interview.id}"].should eql("3")
		statistics["#{interview.id}"].should eql("5")
	end
end
