source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "devise"
gem "devise-i18n"
gem "i18n-js"
gem "jbuilder", "~> 2.7"
gem "kaminari" # Paginator
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1" # Use Puma as the app server
gem "rails", "~> 6.0.3", ">= 6.0.3.4"
gem "rails-i18n"
gem "ransack" # Search
gem "rolify" # User roles
gem "rollbar" # Error reporting
gem "sass-rails", ">= 6"
gem "simple_form"
gem "turbolinks", "~> 5"
gem "wdm", ">= 0.1.0", platforms: %i[mingw mswin x64_mingw]
gem "webpacker", "~> 4.0"

## Utilities
gem "deep_cloneable", "~> 3.0.0"
gem "font-awesome-sass", "~> 5.15.1"
gem "roo", "~> 2.8.0" # Excel imports
gem "roo-xls" # .xls support https://github.com/roo-rb/roo-xls READ LICENSE

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 4.0.1"
end

group :test do
  gem "shoulda-matchers", "~> 4.0"
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
