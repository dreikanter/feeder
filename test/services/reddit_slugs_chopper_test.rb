require "test_helper"

class RedditSlugsChopperTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { RedditSlugsChopper }

  let(:non_ascii_url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/" }
  let(:expected_safe_url) { "https://www.reddit.com/r/worldnews/comments/11yg2e7/" }

  def test_happy_path
    assert_equal expected_safe_url, subject.call(non_ascii_url)
  end
end
