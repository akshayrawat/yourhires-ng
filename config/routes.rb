ActionController::Routing::Routes.draw do |map|    

	map.resource :recruiter_sessions
	map.resources :events
	map.resource :calendar, :only => :show

	map.resources :candidates do |candidate_map|
		candidate_map.resources :feedbacks
		candidate_map.resources :recruitment_steps do |recruitment_step_map|
			recruitment_step_map.resources :events do |event_map|
				event_map.resources :feedbacks
			end
		end
	end

	map.candidate_schedule '/candidates/:id/schedule', :controller => "candidates", :action => 'schedule'
	map.candidate_schedule_step '/candidates/:id/schedule_step', :controller => "events", :action => "schedule_step"
	map.event_detail 'candidates/:candidate_id/events/:id/detail', :controller => "events", :action => "show_detail"
	map.dashboard '/dashboard', :controller => "dashboard", :action => 'index'
	map.auto_complete_for_participant '/participants', :controller => 'participants' , :action => "auto_complete_for_participant_name"

	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'

	map.root :controller => :dashboard
end
