class ParticipantsController < ActionController::Base
	auto_complete_for :participant, :name, :limit => 15
end