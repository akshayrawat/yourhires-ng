require 'digest/sha1'

class Recruiter < ActiveRecord::Base

  has_and_belongs_to_many :candidates

  validates_presence_of     :login
  validates_presence_of     :email

  attr_accessible :login, :email, :name, :password, :password_confirmation

  acts_as_authentic

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) 
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

end