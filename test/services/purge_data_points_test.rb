require "test_helper"

# TODO: Freeze time
class PurgeDataPointsTest < Minitest::Test
  def subject
    PurgeDataPoints
  end

  SAMPLE_THRESHOLD = 1

  def test_deletes_old_data_points
    data_point = create(:data_point, created_at: sample_threshold - 1)
    subject.call(threshold: SAMPLE_THRESHOLD)
    assert_not(DataPoint.exists?(data_point.id))
  end

  def test_keep_recent_data_points
    data_point = create(:data_point, created_at: sample_threshold + 1)
    subject.call(threshold: SAMPLE_THRESHOLD)
    assert(DataPoint.exists?(data_point.id))
  end

  private

  def sample_threshold
    SAMPLE_THRESHOLD.months.ago
  end
end
