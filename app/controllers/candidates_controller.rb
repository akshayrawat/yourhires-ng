class CandidatesController < ApplicationController  
  
  def index
    @candidates = current_recruiter.candidates
  end
  
  def new
    @candidate = Candidate.new
  end
  
end