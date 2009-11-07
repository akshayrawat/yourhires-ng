class RecruitmentStepFactory

  class << self
    def create(params = {})
      RecruitmentStep.create!(valid_params.merge(params))
    end

    def valid_params
      {}
    end

    def pairing(params = {})
      RecruitmentStepFactory.create(params.merge(:recruitment_step_type =>                       RecruitmentStepTypeFactory.pairing))
    end

    def interview(params = {})
      RecruitmentStepFactory.create(params.merge(:recruitment_step_type =>                       RecruitmentStepTypeFactory.interview))
    end

    def phone_interview(params = {})
      RecruitmentStepFactory.create(params.merge(:recruitment_step_type =>                       RecruitmentStepTypeFactory.phone_interview))
    end
    
  end
end