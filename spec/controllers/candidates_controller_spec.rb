require File.dirname(__FILE__) + '/../spec_helper'

describe CandidatesController do
	integrate_views

	before(:each) do
		@reshmi = RecruiterFactory.reshmi
		login_as @reshmi
	end

	describe "index" do
		it "should list candidates assigned to recruiter" do
			maria = RecruiterFactory.maria

			CandidateFactory.create(:name => "Arnab", :recruiters => [maria])
			CandidateFactory.create(:name => "Karan", :recruiters => [@reshmi])
			CandidateFactory.create(:name => "Dilkash", :recruiters => [@reshmi])

			get :index

			response.should render_template("index")
			response.should have_tag("a", "Karan")
			response.should have_tag("a", "Dilkash")
			response.should_not have_tag("a", "Arnab")
		end
	end

	describe "new" do
		it "should show fields for creating new candidate" do    
			developer, ba = RoleFactory.developer, RoleFactory.ba
			pairing, interview = RecruitmentStepTypeFactory.pairing, RecruitmentStepTypeFactory.interview

			get :new

			response.should render_template("new")

			["candidate_name", "candidate_email", "candidate_phone", "candidate_source", "candidate_resume", "recruiter_selection",
				"candidate_skillset", "candidate_comments", "candidate_role_id", "recruitment_step_selection", "candidate_submit"].each do |input_field|
					response.should have_tag("*[id=?]", input_field)
				end
				response.should have_tag("form[action=?]", candidates_path)
				response.should have_tag("select#candidate_role_id option", ba.name)
				response.should have_tag("select#candidate_role_id option", developer.name)
				response.should have_tag("select#recruitment_step_selection option", pairing.name)
				response.should have_tag("select#recruitment_step_selection option", interview.name)
				response.should have_tag("select#recruiter_selection option", @reshmi.name)
			end
		end

		describe "create" do
			it "should create a new candidate when posted with valid params" do
				post :create, :candidate => CandidateFactory.valid_params.merge(:name => "Karan Peri")

				response.should redirect_to(candidates_url)
				candidate= Candidate.find_by_name("Karan Peri")
				candidate.should_not be_nil
			end

			it "should render errors on validation failure" do
				post :create, :candidate => CandidateFactory.valid_params.merge(:name => "")
				response.should render_template(:new)    
			end
		end

		describe "show" do
			it "should render profile section " do
				candidate = CandidateFactory.create(:name => "arnab", :skillset => "RoR", :comments => "claims to be a Rockstar")
				get :show, :id => candidate.id
				
				response.body.should match(candidate.name)
				response.body.should match(candidate.comments)
				response.body.should match(candidate.skillset)
			end

			it "should render activity section" do
				candidate = CandidateFactory.create(:name => "arnab", :skillset => "RoR", :comments => "claims to be a Rockstar")
				activity = RecruitmentActivity.create(:candidate => candidate, :message => "Code pairing done", :recruiter => candidate.recruiters.first)
				
				get :show, :id => candidate.id
				
				response.body.should match(activity.message)
			end
		end

	end
