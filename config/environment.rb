RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.active_record.timestamped_migrations = false
  config.time_zone = 'UTC'
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  %(<span class="field-error">#{html_tag}</span>)
  
end