require 'test_helper'

class CreateDataPointTest < Minitest::Test
  def subject
    CreateDataPoint
  end

  SERIES = :test_series

  def test_create_data_point
    result = subject.call(SERIES)
    assert(result.is_a?(DataPoint))
    assert(result.persisted?)
  end

  def test_create_data_point_series
    subject.call(SERIES)
    assert(DataPointSeries.exists?(name: SERIES))
  end

  def test_create_series_reference
    result = subject.call(SERIES)
    assert_equal(result.series_id, DataPointSeries.find_by(name: SERIES).id)
  end

  def test_overwrite_created_at
    created_at = 1.day.ago
    result = subject.call(SERIES, created_at: created_at)
    assert_equal(created_at, result.created_at)
  end

  DETAILS = {
    number: 9,
    string: 'banana',
    array: %w[coconut],
    nested_object: { 'hello' => 'world' }
  }.freeze

  def test_persist_details
    result = subject.call(SERIES, **DETAILS)
    DETAILS.each do |key, value|
      assert_equal(result.details[key.to_s], value)
    end
  end
end
