ActionController::Routing::Routes.draw do |map|    

  map.resource :recruiter_sessions
  
  map.resources :events
  map.resources :candidates do |candidate_map|
    candidate_map.resources :events
    candidate_map.resources :recruitment_steps do |recruitment_step_map|
      recruitment_step_map.resources :events
    end
  end
	
  map.candidate_schedule '/candidate/:id/schedule', :controller => "candidates", :action => 'schedule'
  map.candidate_feedbacks '/candidate/:id/feedbacks',:controller => "candidates",:action => 'feedbacks'
  map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'

  map.root :controller => :dashboard
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
