config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

ActionMailer::Base.smtp_settings = {
	:enable_starttls_auto => true,
	:address        => 'smtp.gmail.com',
	:port           => 587,
	:authentication => :plain,
	:user_name      => 'yourhires@gmail.com',
	:password       => "foobarbaz"
}