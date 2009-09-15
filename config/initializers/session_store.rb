# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_yourhires-ng_session',
  :secret      => '06a1f9cb382ac2a67e79fe0df66227d5203216036385bd4700f97072bac2239d5c88481845ac3bbe80e5ef989b51e0e92d86d0ce79b344e81dddfbefa92514af'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
