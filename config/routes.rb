ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  map.resource :session
  map.resources :candidates
  
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'
  
  map.root :dashboard
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
