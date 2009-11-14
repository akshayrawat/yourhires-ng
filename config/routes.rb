ActionController::Routing::Routes.draw do |map|    

  map.resource :recruiter_sessions
  
  map.resources :events
  map.resources :candidates do |candidate_map|
    candidate_map.resources :events
    candidate_map.resources :recruitment_steps do |recruitment_step_map|
      recruitment_step_map.resources :events
    end
  end
  
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'

  map.root :controller => :dashboard
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
