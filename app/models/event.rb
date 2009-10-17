class Event < ActiveRecord::Base
  belongs_to :recruitment_step
  has_many :interviewers
  
  def in_future?
    self.start_time >= Time.now
  end
  
end