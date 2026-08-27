source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "puma", "~> 8.0"
gem "rails", "~> 8.1.3"

group :development do
  gem "brakeman", "~> 8.0", require: false
  gem "bundler-audit", "~> 0.9.1"
  gem "reek", "~> 6.0", require: false
  gem "rubocop", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "standard", ">= 1.0", require: false
  gem "standard-performance", require: false
  gem "yaml-lint", "~> 0.1.2", require: false
end

group :development, :test do
  gem "annotaterb", "~> 4.24"
  gem "factory_bot_rails", "~> 6.2"
  gem "rspec-rails", "~> 8.0"
  gem "simplecov", "~> 0.21"
  gem "webmock", "~> 3.18"
end

gem "aasm", "~> 5.5"
gem "addressable", "~> 2.8"
gem "amazing_print"
gem "bootsnap", "~> 1.16", require: false
gem "callee", "~> 0.3"
# connection_pool 3.x is incompatible with Rails 7.2 (RedisCacheStore passes positional hash)
gem "connection_pool", "~> 2.5"
gem "dotiw", "~> 5.3"
gem "dry-initializer", "~> 3.0", ">= 3.0.4"
gem "dry-types", "~> 1.5", ">= 1.5.1"
gem "dry-validation", "~> 1.7"
gem "feedjira", "~> 4.0"
gem "honeybadger", "~> 6.5"
gem "http", "~> 6.0"
gem "lograge", "~> 0.12"
gem "mimemagic", "~> 0.4"
gem "nokogiri", "~> 1.18"
gem "pg", "~> 1.5"
gem "pry", "~> 0.15"
gem "pry-byebug"
gem "pry-rails", "~> 0.3.9"
gem "redis", "~> 5.0"
gem "rss", "~> 0.3.2"

# TODO: Replace with `http` gem
gem "rest-client", "~> 2.0"
