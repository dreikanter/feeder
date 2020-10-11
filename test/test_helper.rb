require 'simplecov'
SimpleCov.start('rails')

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)

require 'rails/test_help'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/pride'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/minitest'
require 'webmock/minitest'
require_relative './custom_assertions'
require_relative './support/file_helpers'
require_relative './support/feed_test_helper'
require_relative './support/normalizer_test_helper'

DatabaseCleaner.strategy = :transaction
WebMock.enable!

module Minitest
  class Test
    include ActiveSupport::Testing::TimeHelpers
    include FactoryBot::Syntax::Methods
    include FileHelpers

    # TODO: Replace with Rails transactional tests
    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end

    # TODO: Drop this in favor to FileHelpers
    def file_fixture(path)
      File.new(::Rails.root.join('test/fixtures/files', path))
    end
  end
end
