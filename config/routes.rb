ActionController::Routing::Routes.draw do |map|    

  map.resource :recruiter_sessions
  map.resources :candidates do |candidate_map|
    candidate_map.resources :events
  end
  map.resources :events
  
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'

  map.root :controller => :dashboard
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
