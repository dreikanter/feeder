require 'test_helper'

class BestOfHackerNewsTest < Minitest::Test
  include FeedTestHelper

  def subject
    Pull.call(feed)
  end

  def feed_config
    {
      name: 'best-of-hacker-news',
      loader: 'null',
      processor: 'hacker_news',
      normalizer: 'hacker_news',
      url: nil
    }
  end

  REQUESTS = [
    {
      url: 'https://hacker-news.firebaseio.com/v0/beststories.json',
      fixture_path: 'api/hacker_news/beststories.json'
    },
    {
      url: 'https://hacker-news.firebaseio.com/v0/item/25662215.json',
      fixture_path: 'api/hacker_news/25662215.json'
    },
    {
      url: 'https://hacker-news.firebaseio.com/v0/item/25661474.json',
      fixture_path: 'api/hacker_news/25661474.json'
    },
    {
      url: 'https://hacker-news.firebaseio.com/v0/item/25691912.json',
      fixture_path: 'api/hacker_news/25691912.json'
    }
  ].freeze

  def setup
    super

    REQUESTS.each do |request|
      stub_request(:get, request.fetch(:url))
        .to_return(
          headers: { 'Content-Type' => 'application/json' },
          body: file_fixture(request.fetch(:fixture_path)).read
        )
    end
  end

  def expected_fixture_path
    'entities/best_of_hacker_news.json'
  end
end
