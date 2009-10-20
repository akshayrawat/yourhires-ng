require 'digest/sha1'

class Recruiter < ActiveRecord::Base

  has_and_belongs_to_many :candidates

  validates_presence_of :login, :email
  attr_accessible :login, :email, :name, :password, :password_confirmation

  acts_as_authentic

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login)
    u && u.authenticated?(password) ? u : nil
  end

end