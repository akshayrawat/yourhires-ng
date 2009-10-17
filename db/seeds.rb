require File.join(File.dirname(__FILE__),"../spec/enable_factories")

class Seeds

  def sow
    create_roles
    create_recruitment_step_types
    create_recruiters
    create_candidates

    recruiters_signup_for_candidates
    candidates_get_registered_for_recruitment_steps
    recruitment_steps_get_scheduled
  end

  def create_roles
    @software_developer = Role.create!(:name => "Software Developer")
    @business_analyst = Role.create!(:name => "Business Analyst")
    @project_manager= Role.create!(:name => "Project Manager")
  end

  def create_recruiters
    @maria = RecruiterFactory.maria
    @reshmi = RecruiterFactory.reshmi
  end

  def create_candidates
    @arnab= Candidate.create!(:name => "Arnab Mandal", :role => @software_developer, :email => "arnab@mandal.com", :phone => "+91 43567132")
    @karan= Candidate.create!(:name => "Karan Peri", :role => @business_analyst, :email => "karan@peri.com", :phone => "+91 63544139")
    @dilkash = Candidate.create!(:name => "Dilkash Sharma", :role => @software_developer, :email => "dilkash@sharma.com", :phone => "+9163542531")
    @manandeep = Candidate.create!(:name => "Manandeep Singh", :role => @project_manager, :email => "manandeep@singh.com", :phone => "+9162242547")
  end

  def create_recruitment_step_types
    @phone_interview = RecruitmentStepTypeFactory.phone_interview
    @pairing = RecruitmentStepTypeFactory.pairing
    @interview_1 = RecruitmentStepTypeFactory.interview
    @interview_2 = RecruitmentStepTypeFactory.interview
  end

  def recruiters_signup_for_candidates
    @arnab.recruiters= [@maria, @reshmi]
    @karan.recruiters= [@maria]
    @dilkash.recruiters= [@reshmi]
    @manandeep.recruiters= [@maria, @reshmi]

    @arnab.save!; @karan.save!; @manandeep.save!
  end

  def candidates_get_registered_for_recruitment_steps
    @arnab.register_for_steps(@phone_interview, @pairing, @interview_1, @interview_2)
    @dilkash.register_for_steps(@phone_interview, @pairing, @interview_1, @interview_2)
    @karan.register_for_steps(@phone_interview, @interview_1, @interview_2)
    @manandeep.register_for_steps(@phone_interview, @interview_1, @interview_2)
  end

  def recruitment_steps_get_scheduled
    [@arnab, @karan, @dilkash, @manandeep].each do |candidate|
      candidate.recruitment_steps.each do |recruitment_step|
        start_time = random_time
        candidate.schedule(recruitment_step, Event.new(
        :name => recruitment_step.recruitment_step_type.name, :start_time => start_time, :end_time => start_time + 3600))
      end
    end
  end

  def random_time
    day_shift =  [-1, +1, 0][rand(3)]
    hour_shift = [-1,-2,-3,-4,1,2,3,4][rand(8)]
    Time.now + (day_shift * 24 * hour_shift * 60 * 60)
  end 

end

Seeds.new.sow