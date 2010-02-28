class RecruiterFactory

  def self.create(params = {})
    Recruiter.create!(valid_params.merge(params))
  end

  def self.valid_params
    {:login => "maria_#{random_no}", :name => "Maria Anita", :email => "maria_#{random_no}@apple.com", :password => "yourhires", :password_confirmation => "yourhires"}
  end
  
  def self.maria
    create(:login => "maria_#{random_no}", :name => "Maria Anita", :email => "maria_#{random_no}@apple.com")
  end
  
  def self.reshmi
    create(:login => "reshmi_#{random_no}", :name => "Reshmi Shenoy", :email => "reshmi_#{random_no}@apple.com")
  end

	def self.random_no
		rand(1000000)
	end
  
end