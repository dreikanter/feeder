require 'test_helper'

class RedditPointsFetcherTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { RedditPointsFetcher }

  let(:url) { 'https://www.reddit.com/r/worldnews/comments/11yg2e7/germany_shots_fired_at_police_in_reichsbürger/' }
  let(:expected) { 1869 }

  def setup
    stub_request(:get, %r{^https://.*/r/worldnews/comments/})
      .to_return(body: file_fixture('feeds/reddit/libreddit_comments_page.html').read)
  end

  def test_happy_path
    assert_equal expected, subject.call(url)
  end
end
