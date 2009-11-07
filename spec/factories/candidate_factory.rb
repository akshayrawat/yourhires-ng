class CandidateFactory
  
  def self.create(params = {})
    Candidate.create!(valid_params(params).merge(params))
  end
  
  def self.valid_params(params = {})
    {
      :name => "Arnab Mandal",:phone => "+98 1234 5643", :email => "arnab@mandal.com", :source => "referral", :role => RoleFactory.developer, :recruiters => params[:recruiters] || [RecruiterFactory.maria], :recruitment_step_selections => params[:recruitment_step_selections] || [RecruitmentStepTypeFactory.interview.id]
    }
  end
  
  def self.create_registered_with_pairing_and_interview_steps
    pairing = RecruitmentStepTypeFactory.pairing
    interview = RecruitmentStepTypeFactory.interview
    candidate = CandidateFactory.create(:recruitment_step_selections => [pairing, interview])
    candidate
  end
  
end