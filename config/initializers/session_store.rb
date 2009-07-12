# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_nubux_session',
  :secret      => '5bb7bb72494155d9811fa24ff62cbb149275d42423de985074ddb1a60267ade337702cbc9ccd18f9d285c6fb555aa24a479c4a6e02d3011ce352073fd428e321'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
