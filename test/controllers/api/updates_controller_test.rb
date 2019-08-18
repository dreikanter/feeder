require 'test_helper'

module API
  class UpdatesControllerTest < Minitest::Test
    def controller
      API::UpdatesController
    end

    def test_operational
      assert_operational(controller)
    end

    def test_index
      assert_perform(controller, :index, Updates::Index)
    end
  end
end
