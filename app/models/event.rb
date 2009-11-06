class Event < ActiveRecord::Base
  belongs_to :recruitment_step
  has_many :interviewers
  validates_presence_of :start_time, :end_time
  
  def in_future?
    self.start_time >= Time.now
  end
  
end