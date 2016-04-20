Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = "team@freshfoodconnect.org"
  config.routes = false
  config.sign_in_guards = [ActiveGuard]
end
