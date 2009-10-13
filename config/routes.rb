ActionController::Routing::Routes.draw do |map|    
  map.resources :candidates
  
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'
  
  map.resource :recruiter_sessions
  map.root :controller => "recruiter_sessions", :action => "new"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
