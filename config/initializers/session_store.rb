# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rpg_session',
  :secret      => '09385fc7729b3d41be91ab3cd5ef19ce9f70e34ea76d54cd81aa2d2313de849f4a378b8ce7a83537f85a011d5e48118222a36a56a0f0b73efaf3b462c1519dfb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
