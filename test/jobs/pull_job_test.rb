require 'test_helper'

class PullJobTest < Minitest::Test
  def subject
    PullJob
  end

  def feed
    build(:feed, name: :test, import_limit: 0)
  end

  def setup
    stub_request(:get, 'https://example.com/').to_return(status: 200, body: '')
  end

  def test_happy_path
    subject.perform_now(feed)
  end
end
