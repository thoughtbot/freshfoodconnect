source "https://rubygems.org"

ruby "2.3.1"

gem "autoprefixer-rails", '>= 6.4.1'
gem "bourbon", "5.0.0.beta.5"
gem "chronic"
gem "clearance", "~> 1.13.0"
gem "delayed_job_active_record"
gem "email_validator"
gem "flutie"
gem "geocoder"
gem "high_voltage"
gem "honeybadger"
gem "inline_svg"
gem "jquery-rails"
gem "neat", "~> 1.7.0"
gem "newrelic_rpm", ">= 3.9.8"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 4.2.7.1"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0.6"
gem "simple_form"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6", ">= 0.9.1"
gem "time_for_a_boolean"
gem "title"
gem "uglifier"
gem "validates_zipcode"

group :development do
  gem "quiet_assets"
  gem "refills"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.4.0"
end

group :development, :staging do
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "capybara-email"
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "email_spec"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
end
