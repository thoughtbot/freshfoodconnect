Clearance.configure do |config|
  config.allow_sign_up = false
  config.mailer_sender = ENV.fetch("SMTP_FROM")
  config.routes = false
  config.sign_in_guards = [ActiveGuard]
end
