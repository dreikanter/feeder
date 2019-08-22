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

  SERIES_A = :a
  SERIES_B = :b
  DETAILS = { key: :value }.freeze

  def test_for_include
    series = create(:data_point_series)
    dp = subject.create!(series: series)
    ids = subject.for(series.name).pluck(:id)
    assert(ids.include?(dp.id))
  end

  def test_for_exclude
    series = create(:data_point_series)
    dp = subject.create!(series: create(:data_point_series))
    ids = subject.for("different_from_#{series.name}").pluck(:id)
    refute(ids.include?(dp.id))
  end

  def test_series
    series = create(:data_point_series)
    records = subject.create!(series: series)
    assert(records.series.present?)
  end

  def random_time
    Time.new.utc - rand(0..1_000_000)
  end

  AMOUNT_OF_SAMPLES = 3

  def test_ordered_scope
    series = create(:data_point_series)
    AMOUNT_OF_SAMPLES.times do
      subject.create!(series: series, created_at: random_time)
    end
    expected = subject.order(created_at: :desc).pluck(:id)
    result = subject.ordered.pluck(:id)
    assert(expected, result)
  end

  def test_recent_scope
    series = create(:data_point_series)
    (DataPoint::RECENT_LIMIT + 1).times do
      subject.create!(series: series, details: DETAILS)
    end
    assert(subject.recent.count <= DataPoint::RECENT_LIMIT)
  end
end
