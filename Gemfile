source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end
gem 'devise'
gem 'gravatar_image_tag'
gem 'image_processing'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.5', '>= 6.0.5.1'
gem 'ransack'
gem 'sass-rails', '>= 6'
gem 'sidekiq', '~> 6.5'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier'
gem 'view_component', '~> 2.71'
gem 'webpacker', '~> 4.0'
group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem

group :development, :test do
  gem 'rubocop'
  gem 'rubocop-minitest' # or gem 'rubocop-rspec' depending on your test suite
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end
