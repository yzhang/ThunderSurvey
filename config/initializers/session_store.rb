# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_Confforge_session',
  :secret => '8cc3715f564745f0fa81bbace47d1e7cace476dfd1e148213ce669dccb83c94accc7b6ddcef476e542ce7793741a02022fb163fe009d426336134ca93abe0abf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
