class Feedback < ActiveRecord::Base
  belongs_to :interviewer
  validates_presence_of :comment
end