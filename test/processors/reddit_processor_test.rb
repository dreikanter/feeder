require 'test_helper'

class RedditProcessorTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { RedditProcessor }
  let(:content) { file_fixture('feeds/reddit/feed.xml').read }

  let(:feed) do
    build(
      :feed,
      url: 'https://www.reddit.com/r/worldnews/.rss',
      loader: 'http',
      processor: 'reddit',
      normalizer: 'reddit'
    )
  end

  let(:expected_uids) do
    %w[
      https://www.reddit.com/r/worldnews/comments/143yos2/rworldnews_live_thread_russian_invasion_of/
      https://www.reddit.com/r/worldnews/comments/1448dgc/wagner_mercenaries_tortured_me_and_stole_tanks/
      https://www.reddit.com/r/worldnews/comments/144a40r/russian_forces_accused_of_blocking_flood/
    ]
  end

  def setup
    DataPoint.delete_all

    stub_request(:get, %r{^https://.*/r/worldnews/comments/})
      .to_return(body: file_fixture('feeds/reddit/libreddit_comments_page.html').read)
  end

  def test_fetches_reddit_points
    entities = subject.call(content, feed: feed, import_limit: 0)
    sample_uids = entities[0, 3].map(&:uid)
    assert_equal expected_uids, sample_uids
  end
end
