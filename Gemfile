source "https://rubygems.org"
ruby "2.0.0"

gem "rails", "~> 3.2.21"
gem "pg"
gem "jquery-rails"
gem "authlogic"
gem "stringex"
gem "will_paginate"
gem "delayed_job_active_record"
gem "workless"
gem "daemons"
gem "hashie"
gem "rails-backbone"
gem "marionette-rails"
gem "backbone-support"
gem "handlebars_assets"

group :assets do
  gem "sass-rails"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
  gem "turbo-sprockets-rails3"
end

group :production do
  gem "unicorn"
  gem "newrelic_rpm"
  gem "heroku_rails_deflate"
  gem "rails_12factor"
end

group :development, :test do
  gem "thin"
  gem "pry-rails"
  gem "foreman"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "awesome_print"
  gem "rspec-rails"
  gem "quiet_assets"
end

group :test do
  gem "rake" # for Travis-CI
  gem "spork"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "fuubar"
  gem "timecop"
  gem "activerecord-nulldb-adapter"
  gem "simplecov"
end
