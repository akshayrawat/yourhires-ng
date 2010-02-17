require 'digest/sha1'

class Recruiter < ActiveRecord::Base

	has_and_belongs_to_many :candidates

	validates_presence_of :login, :email, :name
	attr_accessible :login, :email, :name, :password, :password_confirmation

	acts_as_authentic

	def self.authenticate(login, password)
		return nil if login.blank? || password.blank?
		u = find_by_login(login)
		u && u.authenticated?(password) ? u : nil
	end

	def upcoming_events
		candidates.collect do |candidate|
			candidate.recruitment_steps_upcoming.collect(&:event)
		end.flatten
	end

	def completed_events
		candidates.collect do |candidate|
			candidate.recruitment_steps_completed.collect(&:event)
		end.flatten		
	end

	def unscheduled_recruitment_steps
		candidates.collect do |candidate|
			candidate.recruitment_steps_unscheduled
		end.flatten
	end

end