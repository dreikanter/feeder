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
# TODO: Refactor with Callee
class CheckSequenceRunner
  def self.call(options = {})
    new(options).call
  end

  # NOTE: Dry::Initializer is not used here, since it introduce a number
  # of methods with check_ prefix. This isn't helping to simplify this class.

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def call
    names = failed_check_names
    names.empty? ? Success.new : Failure.new(names)
  end

  def checks
    methods.select { |method| method_is_a_check?(method) }
  end

  def method_prefix
    'check_'
  end

  protected

  def method_is_a_check?(method_name)
    value = method_name.to_s
    value.starts_with?(method_prefix) && (value.length > method_prefix.length)
  end

  def failed_checks
    checks.reject { |method| send(method) }
  end

  def failed_check_names
    from = method_prefix.length
    failed_checks.map { |method| method.to_s[from..-1].to_sym }
  end
end
