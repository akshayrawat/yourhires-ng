class RecruitmentActivityObserver < ActiveRecord::Observer
  observe :candidate, :event, :feedback
  
  def after_create record
    RecruitmentActivity.send "#{record.class.name.downcase}_event", {:operation => :created,
		:record => record}		
  end
  
  def after_update record
    RecruitmentActivity.send "#{record.class.name.downcase}_event", {:operation => :updated,
		:record => record}
  end

end