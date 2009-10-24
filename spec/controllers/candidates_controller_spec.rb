require File.dirname(__FILE__) + '/../spec_helper'

describe CandidatesController do
  integrate_views
  
  it "#index should list candidates assigned to recruiter" do
    maria = RecruiterFactory.maria
    reshmi = RecruiterFactory.reshmi
    
    login_as maria
    
    CandidateFactory.create(:name => "Arnab", :recruiters => [maria])
    CandidateFactory.create(:name => "Karan", :recruiters => [maria])
    CandidateFactory.create(:name => "Dilkash", :recruiters => [reshmi])

    get :index

    response.should render_template("index")
    response.should have_tag("a", "Arnab")
    response.should have_tag("a", "Karan")
    response.should_not have_tag("a", "Dilkash")
  end
  
  it "#new should show fields for creating new candidate" do
    maria = RecruiterFactory.maria
    reshmi = RecruiterFactory.reshmi

    login_as maria
    
    developer, ba = RoleFactory.developer, RoleFactory.ba
    pairing, interview = RecruitmentStepTypeFactory.pairing, RecruitmentStepTypeFactory.interview
    
    get :new
    
    response.should render_template("new")

    ["candidate_name", "candidate_email", "candidate_phone", "candidate_source", "candidate_resume", "recruiter_selection",
      "candidate_skillset", "candidate_comments", "candidate_role", "recruitment_step"].each do |input_field|
          response.should have_tag("*[id=?]", input_field)
    end
    
    response.should have_tag("form[action=?]", candidates_path)

    response.should have_tag("select#candidate_role option", ba.name)
    response.should have_tag("select#candidate_role option", developer.name)

    
    response.should have_tag("select#recruitment_step option", pairing.name)
    response.should have_tag("select#recruitment_step option", interview.name)
    
    response.should have_tag("select#recruiter_selection option", maria.name)
    response.should have_tag("select#recruiter_selection option", reshmi.name)
  end
  
end
