ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/reporters'
require 'minitest/pride'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  include FactoryBot::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

Minitest::Reporters.use!([Minitest::Reporters::SpecReporter.new])
