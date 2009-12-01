module ApplicationHelper

  def format_time(time)
    time.strftime("%I:%M %p")
  end

  def format_datetime(datetime)
    datetime.strftime("%I:%M %p, %b #{datetime.day.ordinalize}")
  end

end
