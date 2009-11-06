ActionController::Routing::Routes.draw do |map|    

  map.resources :candidates do |candidate_map|
    candidate_map.resources :events
  end
  map.resources :events
  
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'
  
  map.resource :recruiter_sessions
  map.root :controller => :dashboard
    
  map.event_details 'event/event_details', :controller => 'events', :action => "event_details"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
