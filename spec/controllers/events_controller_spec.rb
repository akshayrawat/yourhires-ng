require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
  integrate_views

  before(:each) do
    @maria = RecruiterFactory.maria
    login_as @maria
  end

  it "#index should list upcoming events for recruiter" do
    candidate= CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])

    pairing = RecruitmentStepFactory.pairing(:event => EventFactory.create_in_past)
    interview = RecruitmentStepFactory.interview(:event => EventFactory.create_in_future)

    candidate.recruitment_steps = [pairing, interview]

    get :index

    response.should have_tag("*[id=?]", interview.event.id)
    response.should_not have_tag("*[id=?]", pairing.event.id)
  end

  describe "#new" do
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

    it "should list all current recruiter`s candidates available for selection" do
      candidate_one = CandidateFactory.create(:name => "Arnab", :recruiters => [@maria])
      candidate_two= CandidateFactory.create(:name=> "Karan",:recruiters=> [RecruiterFactory.reshmi])

      get :new

      response.should have_tag("select#candidate_id option", candidate_one.name)
      response.should_not have_tag("select#candidate_id option", candidate_two.name)
    end

  end

end