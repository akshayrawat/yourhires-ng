class Candidate < ActiveRecord::Base

	has_many :recruitment_steps, :include => ["event"], :order => "events.start_time ASC", :dependent => :destroy
	
	has_and_belongs_to_many :recruiters
	belongs_to :role
	has_attached_file :resume

	validates_presence_of :name, :phone, :email, :source, :role_id, :recruitment_steps, :recruiters

	def participants
		interviewers.collect{|interviewer|interviewer.participant}.uniq
	end

	def interviewers
		recruitment_steps.select(&:scheduled?).collect do |recruitment_step|
			recruitment_step.event.interviewers
		end.flatten
	end

	def schedule(recruitment_step, event)
		raise "Candidate not registered for this step" unless recruitment_steps.any?{|step|step.id == recruitment_step.id}
		recruitment_step.event= event
	end

	def recruitment_steps_completed
		recruitment_steps.select(&:completed?)
	end

	def recruitment_steps_upcoming
		recruitment_steps.select(&:upcoming?)
	end

	def recruitment_steps_scheduled
		recruitment_steps.select(&:scheduled?)		
	end 

	def recruitment_steps_unscheduled
		recruitment_steps.select(&:unscheduled?)
	end

	def feedbacks
		recruitment_steps_scheduled.collect do |recruitment_step|
			recruitment_step.event.interviewers.collect do |interviewer|
				interviewer.feedbacks
			end
		end.flatten.sort
	end 

	def recruitment_step_type_selections=(recruitment_step_types)
		register_for_steps(RecruitmentStepType.find_all_by_id(recruitment_step_types))
	end

	def recruitment_step_deselections=(recruitment_steps)
		self.recruitment_steps.delete(RecruitmentStep.find_all_by_id(recruitment_steps))
	end

	def recruiter_selections=(recruiters)
		self.recruiters << Recruiter.find_all_by_id(recruiters.uniq)
	end

	def recruiter_deselections=(recruiters)
		self.recruiters.delete(Recruiter.find_all_by_id(recruiters))
	end

	def register_for_steps(step_types)
		step_types.each do |step_type|
			self.recruitment_steps.build(:recruitment_step_type => step_type)
		end
	end

end