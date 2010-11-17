# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_coolpur_session',
  :secret      => '3250fad170e87d256aabbfd097cf61d613dce15bd4afd83134d9196b2a980541111c3311c7184e8ff1e59f7090f7bdda99ecaee4598ff156d711acc11da8d784'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store