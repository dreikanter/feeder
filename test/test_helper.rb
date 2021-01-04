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
require_relative './support/feed_test_helper'
require_relative './support/normalizer_test_helper'

DatabaseCleaner.strategy = :transaction
WebMock.enable!

module Minitest
  class Test
    include ActiveSupport::Testing::TimeHelpers
    include FactoryBot::Syntax::Methods

    # TODO: Replace with Rails transactional tests
    def setup
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end

    def file_fixture(path, scope: 'files')
      File.new(file_fixture_path(path, scope: scope))
    end

    # TODO: Move to a factory
    # :reek:FeatureEnvy
    def normalized_entity_fixture(path, attributes = {})
      file = file_fixture(path, scope: 'normalized_entities')
      entity = JSON.parse(file.read)
      value = entity['published_at']
      entity['published_at'] = DateTime.parse(value) if value
      NormalizedEntity.new(entity.merge(attributes).symbolize_keys)
    end

    private

    def file_fixture_path(path, scope:)
      ::Rails.root.join('test/fixtures', scope, path)
    end
  end
end
