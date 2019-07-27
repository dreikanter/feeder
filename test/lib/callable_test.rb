require 'test_helper'

class CallableTest < Minitest::Test
  def subject
    Callable
  end

  EXPECTED_RESULT = Object.new.freeze

  class SampleCallable < Callable
    def call
      EXPECTED_RESULT
    end
  end

  def test_class_is_callable
    subject.respond_to?(:call)
  end

  def test_instance_is_callable
    subject.new.respond_to?(:call)
  end

  def test_accept_arbitrary_args
    assert_equal(EXPECTED_RESULT, SampleCallable.call)
    assert_equal(EXPECTED_RESULT, SampleCallable.call('param', 'param'))
    assert_equal(EXPECTED_RESULT, SampleCallable.call(option: 'value'))
    assert_equal(EXPECTED_RESULT, SampleCallable.call('param', option: 'value'))
  end

  def test_is_abstract
    assert_raises(NotImplementedError) { subject.call }
  end
end
