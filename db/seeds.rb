require File.join(File.dirname(__FILE__),"../spec/enable_factories")

class Seeds

	def sow
		create_roles
		create_recruitment_step_types
		create_recruiters

		login

		create_candidates
		create_participants

		candidates_get_registered_for_recruitment_steps
		recruitment_steps_get_scheduled

		save

		assign_interviewers
		provide_feedback

		save
	end

	def login
		Authlogic::Session::Base.controller = Authlogic::TestCase::MockController.new    
		RecruiterSession.create(@maria)
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
		@maria = RecruiterFactory.create(:login => "maria", :name => "Maria Anita")
		@reshmi = RecruiterFactory.create(:login => "reshmi", :name => "Reshmi Shenoy")
	end

	def create_candidates
		@arnab= CandidateFactory.create(
		:name => "Arnab Mandal", :role => @software_developer, :email => "arnab@mandal.com",
		:phone => "+91 43567132", :recruiters => [@maria, @reshmi], :comments => comments,
		:skillset => skillset)

		@karan= CandidateFactory.create(:name => "Karan Peri", :role => @business_analyst, :email =>
		"karan@peri.com", :phone => "+91 63544139", :recruiters => [@maria], 
		:comments => comments, :skillset => skillset)

		@dilkash = CandidateFactory.create(:name => "Dilkash Sharma", :role => @software_developer, 
		:email => "dilkash@sharma.com", :phone => "+9163542531", :recruiters => [@maria,
			@reshmi], :comments => comments, :skillset => skillset)

			@manandeep = CandidateFactory.create(:name => "Manandeep Singh", :role => @project_manager, 
			:email => "manandeep@singh.com", :phone => "+9162242547", :recruiters => [@maria,
				@reshmi], :comments => comments, :skillset => skillset)

				@all_candidates = [@arnab, @karan, @dilkash, @manandeep]
			end

			def create_participants
				@nila = Participant.create(:name=> "Nilakanta Mallick",:email => "yourhires.participant@gmail.com")
				@suresh = Participant.create(:name => "Suresh Harikrishnan", :email => "yourhires.participant@gmail.com")
				@irfan_shah = Participant.create(:name => "Irfan Shah", :email => "yourhires.participant@gmail.com")
				@sreeix= Participant.create(:name => "Sreekant Vadagiri", :email => "yourhires.participant@gmail.com")

				@all_participants = [@nila, @suresh, @irfan_shah, @sreeix]
			end

			def candidates_get_registered_for_recruitment_steps
				@arnab.register_for_steps([@phone_interview, @pairing, @interview])
				@dilkash.register_for_steps([@phone_interview, @pairing, @interview])
				@karan.register_for_steps([@phone_interview, @interview, @interview])
				@manandeep.register_for_steps([@phone_interview, @interview, @interview])
			end

			def recruitment_steps_get_scheduled
				@all_candidates.each do |candidate|
					candidate.recruitment_steps[0..-2].each do |recruitment_step|
						start_time = random_time
						candidate.schedule(recruitment_step, Event.new(
						:start_time => start_time, :end_time => start_time + 3600, :venue=> "Room 201", :comment => event_comment))
					end
				end
			end

			def assign_interviewers
				@all_candidates.each do |candidate|
					candidate.recruitment_steps.each do |recruitment_step|
						next if recruitment_step.event.nil?
						rand_interviewer_index= rand(@all_participants.size)
						recruitment_step.event.interviewers = [Interviewer.create(:participant => @all_participants[rand_interviewer_index]), Interviewer.create(:participant => @all_participants[rand_interviewer_index -1 ], :event => recruitment_step.event)]
					end
				end
			end

			def provide_feedback
				@all_candidates[0..-1].collect{|candidate| candidate.recruitment_steps_completed }.flatten.each do |recruitment_step|
					recruitment_step.event.interviewers.each do |interviewer|
						interviewer.feedbacks.create!(:comment => feedback_comment)
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

			def feedback_comment
				"He is a widely known person in the software development community. His strong object oriented skills with deep knowledge of programming languages and frameworks makes him a very strong technically. He seems to be a good fit culturally too. He is a widely known person in the software development community. His strong object oriented skills with deep knowledge of programming languages and frameworks makes him a very strong technically. He seems to be a good fit culturally too. He is a widely known person in the software development community. His strong object oriented skills with deep knowledge of programming languages and frameworks makes him a very strong technically. He seems to be a good fit culturally too. He is a widely known person in the software development community. His strong object oriented skills with deep knowledge of programming languages and frameworks makes him a very strong technically. He seems to be a good fit culturally too. He is a widely known person in the software development community. His strong object oriented skills with deep knowledge of programming languages and frameworks makes him a very strong technically. He seems to be a good fit culturally too."
			end

			def comments
				"He is on leave next week. Expected compensation needs to be negotiated. Travel may need to be arranged for an office interview."
			end

			def skillset
				"Java, Spring, Hibernate, Struts2, Tomcat. Ruby on Rails related technologies.Advanced profiency in XP methodologies and tools"
			end

			def event_comment
				"Candidate prefers to be interviewed between 1pm to 3pm on a weekday. Use his mobile phone number to contact him"
			end

		end

		Seeds.new.sow