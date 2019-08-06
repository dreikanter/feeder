# Basic abstraction for a check-list executor
#
# How it works:
#
#  (1) Inherit this class.
#  (2) Define a set of check-methods returning truthy value if a condition
#      is satisfied.
#  (3) "call" instance method will execute all checks, following declaration
#      sequence.
#  (4) Returned result will be an array, containing check names (symbols)
#      that did not pass.
#  (5) Empty array means all clear.
#
module Service
  class CheckSequenceRunner
    include Callee
    include Dry::Monads[:result]

    CHECK_PREFIX = 'check_'.freeze

    def call
      names = failed_check_names
      names.empty? ? Success() : Failure(names)
    end

    private

    def method_is_a_check?(method_name)
      value = method_name.to_s
      value.starts_with?(CHECK_PREFIX) && (value.length > CHECK_PREFIX.length)
    end

    def failed_checks
      checks.reject { |method| send(method) }
    end

    def failed_check_names
      from = CHECK_PREFIX.length
      failed_checks.map { |method| method.to_s[from..-1].to_sym }
    end

    def checks
      methods.select { |method| method_is_a_check?(method) }
    end
  end
end
