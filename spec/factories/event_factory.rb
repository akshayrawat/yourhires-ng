class EventFactory
  
	def self.create(params = {})
		Event.create(valid_params.merge(params))
	end
	
  def self.create_in_past(start_time= 10.minutes.ago, end_time= start_time + 1000)
    EventFactory.create(:start_time => start_time, :end_time => end_time)
  end
  
  def self.create_in_future(start_time= 10.minutes.from_now, end_time= start_time + 1000)
    EventFactory.create(:start_time => start_time, :end_time => end_time)
  end

	def self.valid_params
		{:start_time => 10.minutes.from_now, :end_time => 20.minutes.from_now, :venue=> "Room 301"}
	end
  
end
