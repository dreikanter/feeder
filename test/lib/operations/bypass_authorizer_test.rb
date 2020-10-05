require 'test_helper'

module Operations
  class BypassAuthorizerTest < Minitest::Test
    def subject
      Operations::BypassAuthorizer
    end

    def new_user
      Object.new
    end

    def new_params
      Object.new
    end

    def test_should_bypass
      args = { user: new_user, params: new_params }
      assert(subject.call(**args))
    end

    def test_should_bypass_with_no_context
      assert(subject.call)
    end
  end
end
