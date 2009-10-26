class EventFactory
  
  def self.create_in_past(start_time= 10.minutes.ago, end_time= start_time + 1000)
    Event.create(:start_time => start_time, :end_time => end_time, :venue=> "Room 201")
  end
  
  def self.create_in_future(start_time= 10.minutes.from_now, end_time= start_time + 1000)
    Event.create(:start_time => start_time, :end_time => end_time, :venue=> "Room 301")
  end
  
end
