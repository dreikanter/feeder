require 'simplecov'
SimpleCov.start('rails')

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)

require 'rails/test_help'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/reporters'
require 'minitest/pride'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/minitest'
require 'webmock/minitest'
require_relative './custom_assertions'
require_relative './support/file_helpers'

DatabaseCleaner.strategy = :transaction

module Minitest
  class Test
    include FactoryBot::Syntax::Methods
    include FileHelpers

    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end
  end
end

Minitest::Reporters.use!
