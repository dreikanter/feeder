source "https://rubygems.org"

ruby "3.3.5"

gem "aasm", "~> 5.5"
gem "amazing_print"
gem "bcrypt", "~> 3.1"
gem "bootsnap", require: false
gem "honeybadger", "~> 5.15", ">= 5.15.6"
gem "http", "~> 5.2"
gem "jsbundling-rails"
gem "memo_wise", "~> 1.9"
gem "mimemagic", "~> 0.4.3"
gem "ostruct", "~> 0.6.0"
gem "pg", "~> 1.5"
gem "propshaft"
gem "pry", "~> 0.14"
gem "pry-byebug"
gem "pry-rails", "~> 0.3.9"
gem "puma", "~> 6.4"
gem "rails", "~> 8.0.0.beta1"
gem "redis", "~> 5.3"
gem "rexml", ">= 3.3.4"  # No direct dependency; added to mitigate a CVE
gem "rss"
# gem "stimulus-rails"
gem "turbo-rails"
# gem "tzinfo-data"

group :development do
  # gem "annotate", "~> 3.2"
  gem "brakeman", "~> 6.1", require: false
  gem "bundler-audit", "~> 0.9", require: false
  gem "reek", "~> 6.3", require: false
  gem "rubocop", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", "~> 2.30", require: false
  gem "standard", ">= 1.0", require: false
  gem "standard-performance", require: false
  # gem "web-console"
  gem "yaml-lint", "~> 0.1.2", require: false
end

group :development, :test do
  # gem "debug"
  # gem "marginalia", "~> 1.11"
end

group :test do
  gem "factory_bot_rails", "~> 6.4"
  gem "rspec-rails", "~> 6.1"
  gem "shoulda-matchers", "~> 6.0"
  gem "simplecov", "~> 0.22"
  gem "super_diff", "~> 0.12"
  gem "webmock", "~> 3.23"
end
