require 'test_helper'

module API
  class PostsControllerTest < Minitest::Test
    def controller
      API::PostsController
    end

    def test_operational
      assert_operational(controller)
    end

    def test_index
      assert_perform(controller, :index, Posts::Index)
    end
  end
end
