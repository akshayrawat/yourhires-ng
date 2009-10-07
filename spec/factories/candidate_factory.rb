class CandidateFactory
  
  def self.create(params = {})
    Candidate.create!(valid_params.merge(params))
  end
  
  def self.valid_params
    {}
  end
  
  def self.create_with_pairing_and_interview_recruitment_steps
    candidate = CandidateFactory.create
    pairing = RecruitmentStepType.create(:name => "Pairing")
    interview = RecruitmentStepType.create(:name => "Interview")
    candidate.register_for(pairing, interview)
    candidate
  end
  
end