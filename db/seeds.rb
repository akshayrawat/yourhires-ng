require File.join(File.dirname(__FILE__),"../spec/enable_factories")

class Seeds

  def sow
    create_roles
    create_recruitment_step_types
    create_recruiters
    create_candidates
    create_participants

    recruiters_signup_for_candidates
    candidates_get_registered_for_recruitment_steps
    recruitment_steps_get_scheduled
    assign_interviewers

    save
  end

  def create_roles
    @software_developer = Role.create!(:name => "Software Developer")
    @business_analyst = Role.create!(:name => "Business Analyst")
    @project_manager= Role.create!(:name => "Project Manager")
  end

  def create_recruitment_step_types
    @phone_interview = RecruitmentStepTypeFactory.phone_interview
    @pairing = RecruitmentStepTypeFactory.pairing
    @interview = RecruitmentStepTypeFactory.interview
  end

  def create_recruiters
    @maria = RecruiterFactory.maria
    @reshmi = RecruiterFactory.reshmi
  end

  def create_candidates
    @arnab= CandidateFactory.create(:name => "Arnab Mandal", :role => @software_developer, :email => "arnab@mandal.com", :phone => "+91 43567132")
    @karan= CandidateFactory.create(:name => "Karan Peri", :role => @business_analyst, :email => "karan@peri.com", :phone => "+91 63544139")
    @dilkash = CandidateFactory.create(:name => "Dilkash Sharma", :role => @software_developer, :email => "dilkash@sharma.com", :phone => "+9163542531")
    @manandeep = CandidateFactory.create(:name => "Manandeep Singh", :role => @project_manager, :email => "manandeep@singh.com", :phone => "+9162242547")

    @all_candidates = [@arnab, @karan, @dilkash, @manandeep]
  end

  def create_participants
    @nila = Participant.create(:name => "Nilakanta Mallick")
    @suresh = Participant.create(:name => "Suresh Harikrishnan")
    @irfan_shah = Participant.create(:name => "Irfan Shah")
    @sreeix= Participant.create(:name => "Sreekant Vadagiri")

    @all_participants = [@nila, @suresh, @irfan_shah, @sreeix]
  end


  def recruiters_signup_for_candidates
    @arnab.recruiters= [@maria, @reshmi]
    @karan.recruiters= [@maria]
    @dilkash.recruiters= [@reshmi]
    @manandeep.recruiters= [@maria, @reshmi]
  end

  def candidates_get_registered_for_recruitment_steps
    @arnab.register_for_steps(@phone_interview, @pairing, @interview, @interview)
    @dilkash.register_for_steps(@phone_interview, @pairing, @interview, @interview)
    @karan.register_for_steps(@phone_interview, @interview, @interview)
    @manandeep.register_for_steps(@phone_interview, @interview, @interview)
  end

  def recruitment_steps_get_scheduled
    @all_candidates.each do |candidate|
      candidate.recruitment_steps.each do |recruitment_step|
        start_time = random_time
        candidate.schedule(recruitment_step, Event.new(
        :name => recruitment_step.recruitment_step_type.name, :start_time => start_time, :end_time => start_time + 3600))
      end
    end
  end

  def assign_interviewers
    @all_candidates.each do |candidate|
      candidate.recruitment_steps.each do |recruitment_step|
      recruitment_step.event.interviewers << Interviewer.create(:participant => @all_participants[rand(@all_participants.size)],
                                                                :event => recruitment_step.event)
      end
    end
  end

  def save
    @all_candidates.each {|candidate| candidate.save!}
  end

  def random_time
    day_shift =  [-1, +1, 0][rand(3)]
    hour_shift = [-1,-2,-3,-4,1,2,3,4][rand(8)]
    Time.now + (day_shift * 24 * hour_shift * 60 * 60)
  end 

end

Seeds.new.sow