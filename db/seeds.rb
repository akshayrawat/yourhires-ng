require File.join(File.dirname(__FILE__),"../spec/enable_factories")

class Seeds

	def sow
		create_roles
		create_recruitment_step_types
		create_recruiters

		login

		create_candidates
		create_participants

		recruitment_steps_get_scheduled

		save

		assign_interviewers
		provide_feedback
		
		create_feeds
		save
	end

	def login
		Authlogic::Session::Base.controller = Authlogic::TestCase::MockController.new    
		RecruiterSession.create(@reena)
	end

	def create_roles
		@software_developer = Role.create!(:name => "Senior Developer")
		@business_analyst = Role.create!(:name => "Business Analyst")
		@project_manager= Role.create!(:name => "Project Manager")
	end

	def create_recruitment_step_types
		@phone_interview = RecruitmentStepTypeFactory.phone_interview
		@pairing = RecruitmentStepTypeFactory.pairing
		@interview = RecruitmentStepTypeFactory.interview
		@offer_interview = RecruitmentStepType.create(:name => "Offer Interview")
	end

	def create_recruiters
		@reena = RecruiterFactory.create(:login => "reena", :name => "Reena Teichman")
		@yewande = RecruiterFactory.create(:login => "yewande", :name => "Yewande Ige")
	end

	def create_candidates
		@john= CandidateFactory.create(
		:name => "John Lennon", :role => @software_developer, :email => "john@lennon.com",
		:phone => "+1 435-671-3234", :recruiters => [@reena, @yewande], :comments => comments,
		:skillset => skillset, :recruitment_step_type_selections => [@phone_interview, @pairing, @interview], :resume => resume_file)

		@paul= CandidateFactory.create(:name => "Paul McCartney", :role => @business_analyst, :email =>
		"paul@mccartney.com", :phone => "+1 635-443-0923", :recruiters => [@reena], 
		:comments => comments, :skillset => skillset, :recruitment_step_type_selections => [@phone_interview, @pairing, @interview, @offer_interview], :resume => resume_file)

		@ringo = CandidateFactory.create(:name => "Ringo Starr", :role => @software_developer, 
		:email => "ringo@starr.com", :phone => "+1 635-425-1134", :recruiters => [@reena,
			@yewande], :comments => comments, :skillset => skillset, :recruitment_step_type_selections => [@phone_interview, @pairing, @interview, @offer_interview], :resume => resume_file)

			@george = CandidateFactory.create(:name => "George Harrison", :role => @project_manager, 
			:email => "george@harrison.com", :phone => "+1 622-425-4732", :recruiters => [@reena,
				@yewande], :comments => comments, :skillset => skillset, :recruitment_step_type_selections => [@phone_interview, @pairing, @interview, @offer_interview], :resume => resume_file)

				@all_candidates = [@john, @paul, @ringo, @george]
			end

			def create_participants
				@kris = Participant.create(:name=> "Kris Kemper",:email => "yourhires.participant@gmail.com")
				@christopher = Participant.create(:name => "Christopher George", :email => "yourhires.participant@gmail.com")
				@steve = Participant.create(:name => "Steve Salkin", :email => "yourhires.participant@gmail.com")
				@alex= Participant.create(:name => "Alex Hung", :email => "alex@hung.com")

				@all_participants = [@kris, @christopher, @steve, @alex]
			end

			def recruitment_steps_get_scheduled
				@all_candidates.each do |candidate|
					candidate.recruitment_steps[0..-2].each do |recruitment_step|
						start_time = random_time
						candidate.schedule(recruitment_step, Event.new(
						:start_time => start_time, :end_time => start_time + 3600, :venue=> "Room 201", :comment => event_comment, :document => event_document))
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
						interviewer.feedbacks.create!(:comment => feedback_comment, :feedback_result => random_feedback_result)
					end
				end
			end
			
			def create_feeds
				RecruitmentActivity.create(:candidate => @ringo, :posted_by => @reena.name,
		                  :message => "Feedback for #{@ringo.name} is delayed by 2 days")

				RecruitmentActivity.create(:candidate => @paul, :posted_by => @reena.name,
		                  :message => "Feedback for #{@paul.name} is delayed by a day")
			end
			
			def save
				@all_candidates.each {|candidate| candidate.save!}
			end

			def random_time
				day_shift =  [-1, +1, 0][rand(3)]
				hour_shift = [-1,-2,-3,-4,1,2,3,4][rand(8)]
				Time.now + (day_shift * 24 * hour_shift * 60 * 60)
			end 
			
			def random_feedback_result
				feedback_results = Feedback::FeedbackResult.values
				feedback_results[rand(feedback_results.size)]
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
			
			def resume_file
 				File.new("#{RAILS_ROOT}/tmp/files/resume.pdf")
			end
			
			def event_document
				File.new("#{RAILS_ROOT}/tmp/files/code_review.pdf")
			end
		end

		Seeds.new.sow