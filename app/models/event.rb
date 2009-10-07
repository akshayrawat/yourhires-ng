class Event < ActiveRecord::Base
  belongs_to :recruitment_step
  has_many :interviewers
end