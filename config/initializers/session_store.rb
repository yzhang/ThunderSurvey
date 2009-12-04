# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_doufu_session',
  :secret      => '40c94024968f95288647346328ab9bfdbd4d3e35d855b817bb12fb4f72d80e29fde88fc4de02fa5376a2983554b24077e776e5a9fdf24a1efb2caada170ebbd2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
