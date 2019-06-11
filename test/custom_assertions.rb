require 'minitest/assertions'

module Minitest
  module Assertions
    #
    # Test if a controller can perform operations
    # SEE: lib/operational constraint
    #
    # :reek:UtilityFunction
    def assert_operational(controller)
      controller.instance_methods.include?(:perform)
    end

    #
    # Test if controller action performs specific operation
    #
    def assert_perform(operational_controller, action, operation)
      controller = operational_controller.new

      def controller.perform(operation)
        operation
      end

      assert_equal(controller.send(action), operation)
    end
  end
end
