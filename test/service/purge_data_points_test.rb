require 'test_helper'

class PurgeDataPointsTest < Minitest::Test
  def service
    Service::PurgeDataPoints
  end

  SAMPLE_THRESHOLD = Time.now.utc.freeze

  def test_deletes_old_data_points
    data_point = create(:data_point, created_at: SAMPLE_THRESHOLD - 1)
    service.call(threshold: SAMPLE_THRESHOLD)
    refute(DataPoint.exists?(data_point.id))
  end

  def test_keep_recent_data_points
    data_point = create(:data_point, created_at: SAMPLE_THRESHOLD + 1)
    service.call(threshold: SAMPLE_THRESHOLD)
    assert(DataPoint.exists?(data_point.id))
  end
end
