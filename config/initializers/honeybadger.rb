Honeybadger.configure do |config|
  config.api_key = ENV["FEEDER_HONEYBADGER_API_KEY"] || Rails.application.credentials.honeybadger_api_key
  config.exceptions.ignore += [SignalException]
end
