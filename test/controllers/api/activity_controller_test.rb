require 'test_helper'

module API
  class ActivityControllerTest < Minitest::Test
    def controller
      API::ActivityController
    end

    def test_operational
      assert_operational(controller)
    end

    def test_index
      assert_perform(controller, :show, Operations::Activity::Show)
    end
  end
end
