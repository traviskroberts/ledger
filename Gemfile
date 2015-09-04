source "https://rubygems.org"
ruby "2.0.0"

gem "rails", "~> 3.2.21"

gem "authlogic"
gem "daemons"
gem "delayed_job_active_record"
gem "handlebars_assets"
gem "hashie"
gem "jquery-rails"
gem "pg"
gem "stringex"
gem "will_paginate"
gem "whenever", require: false
gem "workless"

group :assets do
  gem "coffee-rails", "~> 3.2.1"
  gem "sass-rails", "~> 3.2.3"
  gem "turbo-sprockets-rails3"
  gem "uglifier", ">= 1.0.3"
end

group :production do
  gem "newrelic_rpm"
  gem "rails_12factor"
  gem "unicorn"
end

group :development, :test do
  gem "awesome_print"
  gem "capistrano", "~> 3.1"
  gem "capistrano-bundler", "~> 1.1.2"
  gem "capistrano-rbenv", "~> 2.0"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano3-unicorn", "~> 0.2.1"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "foreman"
  gem "pry-rails"
  gem "quiet_assets"
  gem "rspec-rails"
  gem "thin"
end

group :test do
  gem "activerecord-nulldb-adapter"
  gem "database_cleaner"
  gem "fuubar"
  gem "rake" # for Travis-CI
  gem "shoulda-matchers"
  gem "simplecov"
  gem "spork"
  gem "timecop"
end
