require 'test_helper'

module API
  class FeedsControllerTest < Minitest::Test
    def controller
      API::FeedsController
    end

    def test_operational
      assert_operational(controller)
    end

    def test_index
      assert_perform(controller, :index, Feeds::Index)
    end

    def test_show
      assert_perform(controller, :show, Feeds::Show)
    end
  end
end
