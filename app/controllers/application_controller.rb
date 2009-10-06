class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  
  helper :all
  
  filter_parameter_logging :password

  protect_from_forgery

end
