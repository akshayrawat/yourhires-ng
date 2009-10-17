class CandidateFactory
  
  def self.create(params = {})
    Candidate.create!(valid_params.merge(params))
  end
  
  def self.valid_params
    {}
  end
  
  def self.create_with_pairing_and_interview_recruitment_steps
    candidate = CandidateFactory.create
    pairing = RecruitmentStepTypeFactory.pairing
    interview = RecruitmentStepTypeFactory.interview
    candidate.register_for_steps(pairing, interview)
    
    candidate
  end
  
end