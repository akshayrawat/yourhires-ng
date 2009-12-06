require 'spec_helper'

describe ApplicationController do

	context "current_candidate for top level navigation" do
		
		ApplicationController.instance_eval do
			define_method(:index) {}
		end
		
		before(:each) do
			login_as RecruiterFactory.maria			
		end
		
		it "be the one specified by candidate_id" do
			candidate= CandidateFactory.create
			get :index, :candidate_id => candidate.id
			assigns[:candidate].should eql(candidate)
		end

		it "be the one specified by id for candidates controller" do
			@controller = CandidatesController.new
			candidate= CandidateFactory.create
			get :index, :id => candidate.id, :candidate_id => CandidateFactory.create
			assigns[:candidate].should eql(candidate)
		end
		
		it "be nil when nothing is specified" do
			candidate= CandidateFactory.create
			get :index, :candidate_id => nil, :id => nil
			assigns[:candidate].should be_nil
		end
	end

end
