require 'test_helper'

class PullJobTest < Minitest::Test
  def subject
    PullJob
  end

  def feed
    build(:feed, name: :test, import_limit: 0)
  end

  def test_require_success_result
    subject.perform_now(feed)
  end
end
