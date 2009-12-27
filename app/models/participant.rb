class Participant < ActiveRecord::Base
  validates_presence_of :email
end