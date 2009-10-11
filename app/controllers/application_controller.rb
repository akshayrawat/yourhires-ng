class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  
  before_filter :login_required
  helper :all
  
  filter_parameter_logging :password

  protect_from_forgery

end
