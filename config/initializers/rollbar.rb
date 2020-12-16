Rollbar.configure do |config|
  config.access_token = "c62cc6cfc7004c6da9cb5eee8ee366b0"
  config.enabled = Rails.env.production?
  config.person_email_method = "email"
  config.environment = ENV["ROLLBAR_ENV"].presence || Rails.env
end
