source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "puma", "~> 6.4"
gem "rails", "~> 7.0"

group :development do
  gem "brakeman", "~> 6.0", require: false
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
  gem "annotate", "~> 3.2"
  gem "factory_bot_rails", "~> 6.2"
  gem "marginalia", "~> 1.5"
  gem "rspec-rails", "~> 6.0"
  gem "simplecov", "~> 0.21"
  gem "webmock", "~> 3.18"
end

gem "aasm", "~> 5.5"
gem "addressable", "~> 2.8"
gem "amazing_print"
gem "bootsnap", "~> 1.16", require: false
gem "callee", "~> 0.3"
gem "dotiw", "~> 5.3"
gem "dry-initializer", "~> 3.0", ">= 3.0.4"
gem "dry-types", "~> 1.5", ">= 1.5.1"
gem "dry-validation", "~> 1.7"
gem "feedjira", "~> 3.2"
gem "honeybadger", "~> 5.2"
gem "http", "~> 5.1"
gem "lograge", "~> 0.12"
gem "mimemagic", "~> 0.4"
gem "nokogiri", "~> 1.15"
gem "pg", "~> 1.5"
gem "pry", "~> 0.14"
gem "pry-byebug"
gem "pry-rails", "~> 0.3.9"
gem "redis", "~> 5.0"
gem "rss", "~> 0.2.9"

# TODO: Replace with `http` gem
gem "rest-client", "~> 2.0"
