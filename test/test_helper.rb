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

class ActiveSupport::TestCase
  fixtures :all
end

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  include FactoryGirl::Syntax::Methods

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

class Minitest::Test
  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

Minitest::Reporters.use! [ Minitest::Reporters::SpecReporter.new ]
