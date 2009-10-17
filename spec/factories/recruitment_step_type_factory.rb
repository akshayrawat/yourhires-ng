class RecruitmentStepTypeFactory
  
  def self.pairing
    RecruitmentStepType.create!(:name => "Code Pairing")
  end
  
  def self.interview
    RecruitmentStepType.create!(:name => "Office Interview")
  end

  def self.phone_interview
    RecruitmentStepType.create!(:name => "Telephone Interview")
  end
  
end
