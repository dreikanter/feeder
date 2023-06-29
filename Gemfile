source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "puma", "~> 6.3"
gem "rails", "~> 6.0"

group :development do
  gem "brakeman", "~> 6.0", require: false
  gem "bundler-audit", "~> 0.9.1"
  gem "reek", "~> 6.0", require: false
  gem "rubocop", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "standard", ">= 1.0", require: false
  gem "standard-performance", require: false
  gem "yaml-lint", "~> 0.1.2", require: false
end

group :development, :test do
  gem "annotate", "~> 3.2"
  gem "database_cleaner-active_record"
  gem "factory_bot_rails", "~> 4.8", ">= 4.8.2"
  gem "listen", "~> 3.2"
  gem "marginalia", "~> 1.5"
  gem "minitest-rails", "~> 6.0"
  gem "mocha", "~> 1.9"
  gem "rspec-rails", "~> 6.0.0"
  gem "simplecov", "~> 0.21"
  gem "webmock", "~> 3.11"
end

gem "aasm", "~> 5.5"
gem "active_model_serializers", "~> 0.10.9"
gem "addressable", "~> 2.8"
gem "amazing_print"
gem "bootsnap", ">= 1.4.2", require: false
gem "callee", "~> 0.3"
gem "dotiw", "~> 5.3"
gem "dry-initializer", "~> 3.0", ">= 3.0.4"
gem "dry-types", "~> 1.5", ">= 1.5.1"
gem "dry-validation", "~> 1.7"
gem "enu", "~> 0.1.2"
gem "feedjira", "~> 3.2"
gem "honeybadger", "~> 4.0"
gem "http", "~> 4.0"
gem "lograge", "~> 0.3.6"
gem "mimemagic", ">= 0.4.3"
gem "nokogiri", "~> 1.13", ">= 1.13.3"
gem "pg", "~> 1.2", ">= 1.2.3"
gem "pry", "~> 0.14.1"
gem "pry-byebug"
gem "pry-rails", "~> 0.3.9"
gem "redis", "~> 5.0"
gem "rss", "~> 0.2.9"

# TODO: Replace with `http` gem
gem "rest-client", "~> 2.0"

# TODO: Drop this after Twitter API interaction is removed
gem "twitter", "~> 7.0"
