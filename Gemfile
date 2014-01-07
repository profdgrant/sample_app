source 'https://rubygems.org'
ruby '1.9.3'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.2'
gem 'bootstrap-sass', '2.3.2.0'  # styleheet stuff
gem 'bcrypt-ruby', '3.1.2'  # encryption for passwords

group :development, :test do
  gem 'sqlite3', '1.3.8'    # database
  gem 'rspec-rails', '2.13.1'    # rspec testing framework
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

gem 'growl', '1.0.3'

gem 'sass-rails', '4.0.1'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

gem 'rails_12factor', group: :production

group :production do
  gem 'pg', '0.15.1'
end