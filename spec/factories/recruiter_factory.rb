class RecruiterFactory

  def self.create(params)
    Recruiter.create!(valid_params.merge(params))
  end

  def self.valid_params
    {:login => "maria", :name => "Maria Anita", :email => "maria@thoughtworks.com", :password => "yourhires", :password_confirmation => "yourhires"}
  end
  
  def self.maria
    create(:login => "maria", :name => "Maria Anita", :email => "maria@thoughtworks.com")
  end
  
  def self.reshmi
    create(:login => "reshmi", :name => "Reshmi Shenoy", :email => "reshmi@thoughtworks.com")
  end
  
end