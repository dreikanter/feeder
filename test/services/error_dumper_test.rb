require "test_helper"

class ErrorDumperTest < Minitest::Test
  def subject
    ErrorDumper
  end

  def test_can_dump_things
    subject.call
    assert(Error.any?)
  end

  def dump_sample_exception
    raise "sample exception"
  rescue StandardError
    subject.call(exception: $ERROR_INFO)
  end

  def test_returns_error_object
    error = dump_sample_exception
    assert(error.is_a?(Error))
  end

  def test_no_target_by_default
    error = dump_sample_exception
    assert(error.target.nil?)
  end

  def test_target
    target = create(:feed)
    error = subject.call(target: target)
    assert_equal(target, error.target)
  end

  def test_backtrace
    error = dump_sample_exception
    assert(error.backtrace.is_a?(Array))
    assert(error.backtrace.any?)
  end
end
