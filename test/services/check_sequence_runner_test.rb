require 'test_helper'

class CheckSequenceRunnerTest < Minitest::Test
  def subject
    CheckSequenceRunner
  end

  def test_success_when_all_checks_passed
    prefix = subject::CHECK_PREFIX

    sequence = Class.new(subject) do
      define_method("#{prefix}_test") { true }
    end

    assert(sequence.call)
  end

  def test_failure_when_some_checks_are_not_passed
    sequence = Class.new(subject)
    sequence.define_method("#{subject::CHECK_PREFIX}1") { true }
    sequence.define_method("#{subject::CHECK_PREFIX}2") { false }
    assert(sequence.call.failure?)
  end

  def test_return_failed_check_names
    passed_name = :passed_name
    failed_name = :failed_name
    passed = "#{subject::CHECK_PREFIX}#{passed_name}"
    failed = "#{subject::CHECK_PREFIX}#{failed_name}"
    sequence = Class.new(subject)
    sequence.define_method(passed) { true }
    sequence.define_method(failed) { false }
    assert_equal([failed_name], sequence.call.failure)
  end
end
