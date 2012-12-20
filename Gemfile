source 'https://rubygems.org'
gem 'rails', '3.2.9'
gem 'mysql2'
gem 'whiskey_disk'
gem 'jquery-rails'
gem 'authlogic'
gem 'stringex'
gem 'will_paginate'
gem 'sidekiq'
gem 'lograge'
gem 'whenever', :require => false

# for sidekiq webmin
gem 'slim'
gem 'sinatra', :require => nil

group :assets do
  gem 'sass-rails'
  gem 'therubyracer'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'zeus'
  gem 'capistrano'
  gem 'capistrano_colors'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'rspec-rails'
end

group :test do
  gem 'spork'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'fuubar'
  gem 'timecop'
end
