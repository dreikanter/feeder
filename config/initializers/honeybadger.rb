Honeybadger.configure do |config|
  config.api_key = Rails.application.credentials.honeybadger_api_key
end
