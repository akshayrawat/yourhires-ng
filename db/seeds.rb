def create_roles
  Role.create!(:name => "Software Developer")
  Role.create!(:name => "Business Analyst")
  Role.create!(:name => "Quality Analyst")
  Role.create!(:name => "Project Manager")
end

def create_recruiter_with_candidates
  recruiter = Recruiter.create!(:login => "maria", :name => "Maria Anita", :email => "manita@thoughtworks.com", :password => "yourhires", :password_confirmation => "yourhires")

  recruiter.candidates << Candidate.create!(:name => "Arnab Mandal", :role => Role.all[0], :email => "arnab@mandal.com", :phone => "+91 43567132")
  recruiter.candidates << Candidate.create!(:name => "Karan Peri", :role => Role.all[1], :email => "karan@peri.com", :phone => "+91 63544139")
  recruiter.candidates << Candidate.create!(:name => "Dilkash Sharma", :role => Role.all[2], :email => "dilkash@sharma.com", :phone => "+91 63542531")
  
end


create_roles
create_recruiter_with_candidates