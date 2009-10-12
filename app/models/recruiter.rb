class Recruiter < ActiveRecord::Base
  has_and_belongs_to_many :candidates  
end