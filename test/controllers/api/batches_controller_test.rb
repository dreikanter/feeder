require 'test_helper'

module API
  class BatchesControllerTest < Minitest::Test
    def controller
      API::BatchesController
    end

    def test_operational
      assert_operational(controller)
    end

    def test_index
      assert_perform(controller, :index, Operations::Batches::Index)
    end
  end
end
