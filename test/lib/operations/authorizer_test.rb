require 'test_helper'

module Operations
  class AuthorizerTest < Minitest::Test
    def authorizer
      Operations::Authorizer
    end

    def user
      @user ||= Object.new
    end

    def params
      @params ||= Object.new
    end

    def test_bypass_current_user
      result = authorizer.new(user: user, params: params)
      assert_equal(result.user, user)
    end

    def test_bypass_params
      result = authorizer.new(user: user, params: params)
      assert_equal(result.params, params)
    end

    def test_user_should_be_optional
      result = authorizer.new(params: params)
      assert_nil(result.user)
    end

    EXPECTED_DEFAULT_PARAMS = {}.freeze

    def test_params_should_be_optional
      result = authorizer.new(user: user)
      assert_equal(result.params, EXPECTED_DEFAULT_PARAMS)
    end

    def acceptable_arg_variations
      [
        { user: user, params: params },
        { user: user },
        { params: params },
        {}
      ]
    end

    def test_callable
      acceptable_arg_variations.each do |args|
        assert(authorizer.call(**args))
      end
    end
  end
end
