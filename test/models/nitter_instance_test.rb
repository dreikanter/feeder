require 'test_helper'

class NitterInstanceTest < ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  let(:nitter_instance) { create(:nitter_instance) }

  def test_initial_state
    assert nitter_instance.enabled?
  end

  def test_updates_errored_at
    freeze_time do
      nitter_instance.error!
      assert_equal DateTime.now, nitter_instance.errored_at.to_datetime
    end
  end

  def test_counts_errors
    2.times { nitter_instance.error! }
    assert_equal 2, nitter_instance.errors_count
  end

  def test_disables_after_max_errors_limit_exceeded
    nitter_instance.update!(errors_count: NitterInstance::MAX_ERRORS.pred)
    nitter_instance.error!
    assert nitter_instance.disabled?
  end
end
