class RecruitmentStepFactory
  
  def self.create(params = {})
    RecruitmentStep.create!(valid_params.merge(params))
  end
  
  def self.valid_params
    {}
  end
  
end