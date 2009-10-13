class CandidatesController < ApplicationController  
  
  def index
    @candidates = current_recruiter.candidates
  end
  
end