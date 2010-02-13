class CalendarsController < ApplicationController
	skip_before_filter :ensure_login	
	include EventIcalGeneration
	
	def show
		respond_to do |format|
			format.ics{render :text => generate_ical(Event.all)}
			format.any{render :text => "", :status => 400}
		end
	end

end
