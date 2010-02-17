ActionController::Routing::Routes.draw do |map|    

	map.resource :recruiter_sessions
	map.resources :events, :collection => {:events_completed => :get, :events_unscheduled => :get}
	map.resource :calendar, :only => :show

	map.resources :candidates, :collection => {:assigned => :get} do |candidate_map|
		candidate_map.resources :feedbacks
		candidate_map.resources :recruitment_steps do |recruitment_step_map|
			recruitment_step_map.resources :events do |event_map|
				event_map.resources :feedbacks
			end
		end
	end
	
	map.candidate_schedule '/candidates/:id/schedule', :controller => "candidates", :action => 'schedule'
	map.schedule_step '/schedule_step', :controller => "schedule_step", :action => "show"
	map.event_detail 'candidates/:candidate_id/events/:id/detail', :controller => "events", :action => "show_detail"
	map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'
	
	map.auto_complete_for_participant '/participants', :controller => 'participants' , :action => "auto_complete_for_participant_name"
	map.auto_complete_for_candidate '/candidate_search', :controller => "candidates", :action => "auto_complete_for_candidate_name"

	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'

	map.root :controller => :dashboard
end
