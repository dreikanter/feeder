require 'test_helper'

# TODO: Freeze time
class PurgeErrorsTest < Minitest::Test
  def subject
    PurgeErrors
  end

  SAMPLE_THRESHOLD = 1

  def test_deletes_old_errors
    error = create(:error, created_at: sample_threshold - 1)
    subject.call(threshold: SAMPLE_THRESHOLD)
    refute(Error.exists?(error.id))
  end

  def test_keep_recent_errors
    error = create(:error, created_at: sample_threshold + 1)
    subject.call(threshold: SAMPLE_THRESHOLD)
    assert(Error.exists?(error.id))
  end

  private

  def sample_threshold
    SAMPLE_THRESHOLD.months.ago
  end
end
