ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.resources :users
  map.resource :session
  
  map.root :login
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
