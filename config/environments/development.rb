config.cache_classes = false
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.smtp_settings = {
	:enable_starttls_auto => true,
	:address        => 'smtp.gmail.com',
	:port           => 587,
	:authentication => :plain,
	:user_name      => 'yourhires@gmail.com',
	:password       => "foobarbaz"
}