if Rails.env.production?
  SUBURI = "/customerx"
else
  SUBURI = ''
end
#set session timeout minutes
SESSION_TIMEOUT_MINUTES = 90
SESSION_WIPEOUT_HOURS = 12
