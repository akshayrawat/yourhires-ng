class RecruitmentActivityObserver < ActiveRecord::Observer
  observe :candidate, :event
  
  def after_create record
    RecruitmentActivity.send "new_#{record.class.to_s.downcase}", record
  end
  
  def after_update record
    RecruitmentActivity.send "#{record.class.to_s.downcase}_updated", record
  end

end