source 'https://rubygems.org'

gem 'rails', '3.2.14'

# for Heroku deployment
group :development, :test do
  gem 'sqlite3'
  gem 'ruby-debug19'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails'
end

group :test do
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'haml'

gem 'devise'
