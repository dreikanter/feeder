# == Schema Information
#
# Table name: data_points
#
#  id         :integer          not null, primary key
#  series_id  :integer
#  details    :json             not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_data_points_on_series_id  (series_id)
#

require 'test_helper'

class DataPointTest < Minitest::Test
  def subject
    DataPoint
  end

  def test_valid
    assert(subject.new(series: DataPointSeries.new).valid?)
  end

  def setup
    subject.delete_all
  end

  SERIES_A = :a
  SERIES_B = :b
  DETAILS = { key: :value }.freeze

  def test_for
    dp_a = CreateDataPoint.call(SERIES_A)
    dp_b = CreateDataPoint.call(SERIES_B)
    ids = subject.for(SERIES_A).pluck(:id)
    assert(ids.include?(dp_a.id))
    refute(ids.include?(dp_b.id))
  end

  def test_series
    records = CreateDataPoint.call(SERIES_A)
    assert(records.series.present?)
  end

  def random_time
    Time.new.utc - rand(0..1_000_000)
  end

  AMOUNT_OF_SAMPLES = 3

  def test_ordered_scope
    AMOUNT_OF_SAMPLES.times do
      CreateDataPoint.call(SERIES_A, created_at: random_time)
    end
    expected = subject.order(created_at: :desc).pluck(:id)
    result = subject.ordered.pluck(:id)
    assert(expected, result)
  end

  def test_recent_scope
    AMOUNT_OF_SAMPLES.times do
      CreateDataPoint.call(SERIES_A, DETAILS)
    end
    assert(subject.recent.count < DataPoint::RECENT_LIMIT)
  end
end
