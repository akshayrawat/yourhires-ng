class RecruiterFactory

  def self.create(params)
    Recruiter.create!(valid_params.merge(params))
  end

  def self.valid_params
    {:login => "maria", :name => "Maria Anita", :email => "manita@thoughtworks.com", :password => "yourhires", :password_confirmation => "yourhires"}
  end

end