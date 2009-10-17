class RecruitmentStepTypeFactory
  
  def self.pairing
    RecruitmentStepType.create!(:name => "pairing")
  end
  
  def self.interview
    RecruitmentStepType.create!(:name => "interview")
  end

  def self.phone_interview
    RecruitmentStepType.create!(:name => "phone-interview")
  end
  
end
