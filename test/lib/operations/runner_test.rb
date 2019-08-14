require 'test_helper'

module Operations
  class RunnerTest < Minitest::Test
    def subject
      Operations::Runned
    end

    class SampleOperation < Operations::Base
      def call; end
    end

    def new_runner(options = {})
      Runner.new(
        SampleOperation,
        user: Object.new,
        params: {},
        request: Object.new,
        **options
      )
    end

    def test_accept_schema
      schema = Object.new
      runner = new_runner(schema: schema)
      assert_equal(schema, runner.schema)
    end

    def test_default_schema
      runner = new_runner
      expected = Operations::SchemaResolver.call(SampleOperation)
      assert_equal(expected, runner.schema)
    end

    def test_accept_authorizer
      authorizer = Object.new
      runner = new_runner(authorizer: authorizer)
      assert_equal(authorizer, runner.authorizer)
    end

    def test_default_authorizer
      runner = new_runner
      expected = Operations::AuthorizerResolver.call(SampleOperation)
      assert_equal(expected, runner.authorizer)
    end

    def test_validate_params
      # TODO
    end

    def test_authorize_user
      # TODO
    end

    def test_perform_operation
      # TODO
    end
  end
end
