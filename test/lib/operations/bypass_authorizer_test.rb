require 'test_helper'

module Operations
  class BaseAuthorizerTest < Minitest::Test
    def new_user
      Object.new
    end

    def new_params
      Object.new
    end

    def test_should_bypass
      args = { user: new_user, params: new_params }
      assert(Operations::BypassAuthorizer.call(**args).success?)
    end

    def test_should_bypass_with_no_context
      assert(Operations::BypassAuthorizer.call.success?)
    end
  end
end
